# frozen_string_literal: true

module AwsInfraMapper
  module Models
    autoload :Config, 'aws_infra_mapper/models/config'
    autoload :GraphNode, 'aws_infra_mapper/models/graph_node'
    autoload :NodeAdapters, 'aws_infra_mapper/models/node_adapters'
  end
end
