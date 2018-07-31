# frozen_string_literal: true

module AwsInfraMapper
  module GraphBuilders
    class EC2InstanceGraphBuilder < BaseGraphBuilder
      def build_nodes(instances, conf, *)
        label_tmpl = conf.ec2_instance_label

        instance_nodes = instances.map do |instance|
          ::AwsInfraMapper::Models::NodeAdapters::EC2InstanceNodeAdapter.new(instance, label_tmpl)
        end

        dedup = conf.dedup_ec2_instances
        dedup ? dedup_nodes(instance_nodes) : instance_nodes
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

      def dedup_nodes(instance_nodes)
        instance_nodes.each_with_object({}) do |node, deduped_nodes|
          if !deduped_nodes.key? node.node_label
            deduped_nodes.merge!(node.node_label => node)
          else
            existing_node = deduped_nodes[node.node_label]
            existing_node.add_instance_to_cluster_node
          end
        end.values
      end
    end
  end
end
