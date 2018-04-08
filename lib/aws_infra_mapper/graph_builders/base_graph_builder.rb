# frozen_string_literal: true

module AwsInfraMapper
  module GraphBuilders
    class BaseGraphBuilder
      def build(graph, *args)
        graph.merge!(
          GRAPH_DATA_NODES_KEY => build_nodes(*args) || [],
          GRAPH_DATA_EDGES_KEY => build_edges(*args) || []
        ) { |_, existing, new| existing + new }
      end

      def build_nodes(*)
        ## Should return a list of nodes hashes (null is acceptable)
        raise NotImplementedError, 'You must implement build_nodes'
      end

      def build_edges(*)
        ## Should return a list of edges hashes (null is acceptable)
        raise NotImplementedError, 'You must implement build_edges'
      end
    end
  end
end
