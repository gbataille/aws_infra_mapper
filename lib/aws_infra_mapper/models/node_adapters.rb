# frozen_string_literal: true

module AwsInfraMapper
  module Models
    module NodeAdapters
      autoload :EC2InstanceNodeAdapter,
               'aws_infra_mapper/models/node_adapters/ec2_instance_node_adapter'
    end
  end
end
