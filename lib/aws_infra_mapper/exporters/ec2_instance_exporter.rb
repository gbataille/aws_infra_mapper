# frozen_string_literal: true

module AwsInfraMapper
  module Exporters
    class EC2InstanceExporter
      def self.as_node(ec2_instance)
        ## Takes an Aws::EC2::Types::Instance and turn it into a generic graph node
        {
          NODE_KEY_TYPE => NODE_TYPE_EC2_INSTANCE,
          NODE_KEY_LABEL => ec2_instance.instance_id
        }
      end
    end
  end
end
