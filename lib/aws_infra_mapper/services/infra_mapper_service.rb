# frozen_string_literal: true

require 'json'
require 'pathname'

module AwsInfraMapper
  module Services
    class InfraMapperService
      def initialize
        @ec2_service = Aws::EC2Service.new
      end

      def export(work_dir = nil, filename = nil)
        data = infra_data

        work_dir ||= DEFAULT_EXPORT_DIR
        filename ||= DEFAULT_EXPORT_FILENAME
        filepath = Pathname.new(work_dir).join(filename)

        File.open(filepath, 'w') do |f|
          f.write JSON.dump(data)
        end
      end

      def infra_data
        {
          GRAPH_DATA_NODES_KEY => nodes,
          GRAPH_DATA_EDGES_KEY => edges
        }
      end

      private

      def nodes
        instance_nodes
      end

      def edges
        []
      end

      def instance_nodes
        @ec2_service.instances.map { |i| Exporters::EC2InstanceExporter.as_node(i) }.to_a
      end
    end
  end
end
