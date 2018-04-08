# frozen_string_literal: true

module AwsInfraMapper
  module Exporters
    class AwsRouteExporter
      def self.as_edge(route)
        {
          NODE_KEY_SOURCE => route[:source],
          NODE_KEY_TARGET => route[:target],
          NODE_KEY_DATA => route[:data]
        }
      end
    end
  end
end
