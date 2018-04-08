# frozen_string_literal: true

module AwsInfraMapper
  module GraphBuilders
    class EC2InstanceGraphBuilder < BaseGraphBuilder
      def build_nodes(instances, *)
        instances.map { |i| Exporters::EC2InstanceExporter.as_node(i) }.to_a
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
    end
  end
end
