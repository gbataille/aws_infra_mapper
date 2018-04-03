# frozen_string_literal: true

require 'json'
require 'pathname'

module AwsInfraMapper
  module Services
    class InfraMapperService
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
        []
      end

      def edges
        []
      end
    end
  end
end
