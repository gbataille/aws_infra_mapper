# frozen_string_literal: true

module AwsInfraMapper
  module GraphBuilders
    class EC2InstanceGraphBuilder < BaseGraphBuilder
      def build_nodes(instances, conf, *)
        label_tmpl = conf.ec2_instance_label
        dedup = conf.dedup_ec2_instances

        dedup ? deduped_instances(instances, label_tmpl) : all_ec2_instances(instances, label_tmpl)
      end

      def build_edges(instances, security_groups, *)
        routes = []
        idx = index_instances_by_sg(instances)

        sg_to_sg_map(security_groups).each do |sg_map|
          idx[sg_map[:from]].each do |instance_src|
            idx[sg_map[:to]].each do |instance_dest|
              routes << { source: instance_src.instance_id, target: instance_dest.instance_id }
            end
          end
        end

        routes.map { |r| Exporters::AwsRouteExporter.as_edge(r) }
      end

      private

      def index_instances_by_sg(instances)
        index = instances.reduce({}) do |idx, instance|
          instance_by_sg = instance.security_groups.reduce({}) do |h, sg|
            h.merge!(sg.group_id => [instance])
          end

          idx.merge!(instance_by_sg) { |_, a, b| a + b }
        end
        index.default = []
        index
      end

      def sg_to_sg_map(security_groups)
        security_groups.each_with_object([]) do |sg, acc|
          sg.ip_permissions.each do |ip_perm|
            ip_perm.user_id_group_pairs.each do |group_pair|
              acc << { from: group_pair.group_id, to: sg.group_id }
            end
          end
        end
      end

      def deduped_instances(instances, label_tmpl)
        exporter = Exporters::EC2InstanceExporter.new
        idx = instances.each_with_object({}) do |instance, uniq|
          label = exporter.node_label(instance, label_tmpl)
          if uniq.key? label
            uniq[label][NODE_KEY_TYPE] = NODE_TYPE_EC2_INSTANCES_CLUSTER
          else
            uniq.merge!(label => exporter.as_node(instance, label_tmpl))
          end
        end
        idx.values
      end

      def all_ec2_instances(instances, label_tmpl)
        exporter = Exporters::EC2InstanceExporter.new
        instances.map do |i|
          exporter.as_node(i, label_tmpl)
        end.to_a
      end
    end
  end
end
