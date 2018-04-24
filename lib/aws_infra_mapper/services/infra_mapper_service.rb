# frozen_string_literal: true

require 'json'
require 'pathname'

module AwsInfraMapper
  module Services
    class InfraMapperService
      def initialize(conf, vpc_filter: nil)
        @conf = conf
        @ec2_service = Aws::EC2Service.new
        @ec2_service.add_vpc_filter(vpc_filter) unless vpc_filter.nil?
        load_data
      end

      def export(work_dir: nil, filename: nil)
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
        node_ids = instance_nodes.map { |i| i[NODE_KEY_ID] }
        GraphBuilders::EC2InstanceGraphBuilder.new.build_edges(
          @ec2_instances, @security_groups, node_ids
        )
      end

      def instance_nodes
        GraphBuilders::EC2InstanceGraphBuilder.new.build_nodes(@ec2_instances, @conf)
      end
    end
  end
end
