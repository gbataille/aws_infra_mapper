# frozen_string_literal: true

module AwsInfraMapper
  module GraphBuilders
    class EC2InstanceGraphBuilder < BaseGraphBuilder
      def build_nodes(instances, conf, *)
        label_tmpl = conf.ec2_instance_label
        dedup = conf.dedup_ec2_instances

        dedup ? deduped_instances(instances, label_tmpl) : all_ec2_instances(instances, label_tmpl)
      end

      def build_edges(aws_instances, security_groups, filtered_node_ids, *)
        routes = []
        idx = index_instances_by_sg(aws_instances)

        sg_to_sg_map(security_groups).each do |sg_map|
          pairs = build_instances_connection(
            sg_map[:from], sg_map[:to], idx, filtered_node_ids
          )
          routes.concat(
            pairs.map { |pair| { source: pair[0].instance_id, target: pair[1].instance_id } }
          )
        end

        routes.map { |r| Exporters::AwsRouteExporter.as_edge(r) }
      end

      private

      def build_instances_connection(sg_from, sg_to, idx_instances_by_sg, filtered_node_ids)
        src_instances = idx_instances_by_sg[sg_from]
        dest_instances = idx_instances_by_sg[sg_to]

        src_instances.keep_if { |i| filtered_node_ids.include? i.instance_id }
        dest_instances.keep_if { |i| filtered_node_ids.include? i.instance_id }

        src_instances.product(dest_instances)
      end

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
            upgrade_cluster_node uniq[label]
          else
            uniq.merge!(label => exporter.as_node(instance, label_tmpl))
          end
        end
        idx.values
      end

      def upgrade_cluster_node(node)
        type = node[NODE_KEY_TYPE]
        if type == NODE_TYPE_EC2_INSTANCE
          node[NODE_KEY_TYPE] = NODE_TYPE_EC2_INSTANCES_CLUSTER
          node[NODE_KEY_LABEL] += ' (2)'
        else
          node[NODE_KEY_LABEL].sub!(/(.*)\s\((\d+)\)/) do
            "#{Regexp.last_match(1)} (#{Regexp.last_match(2).to_i + 1})"
          end
        end
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
