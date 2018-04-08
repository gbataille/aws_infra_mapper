# frozen_string_literal: true

require 'json'
require 'pathname'

module AwsInfraMapper
  module Services
    class InfraMapperService
      def initialize
        @ec2_service = Aws::EC2Service.new
        load_data
      end

      def export(work_dir = nil, filename = nil)
        $LOGGER.info 'Retrieving the AWS data. This may take a while.'

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

      def load_data
        @ec2_instances = @ec2_service.instances
        @security_groups = @ec2_service.security_groups
      end

      def nodes
        instance_nodes
      end

      def edges
        instance_edges
      end

      def instance_edges
        GraphBuilders::EC2InstanceGraphBuilder.new.build_edges(@ec2_instances, @security_groups)
      end

      def instance_nodes
        GraphBuilders::EC2InstanceGraphBuilder.new.build_nodes(@ec2_instances)
      end
    end
  end
end
