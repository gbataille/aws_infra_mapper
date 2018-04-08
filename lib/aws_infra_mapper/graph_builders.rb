# frozen_string_literal: true

module AwsInfraMapper
  module GraphBuilders
    autoload :BaseGraphBuilder,
             'aws_infra_mapper/graph_builders/base_graph_builder.rb'
    autoload :EC2InstanceGraphBuilder,
             'aws_infra_mapper/graph_builders/ec2_instance_graph_builder.rb'
  end
end
