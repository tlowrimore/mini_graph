require 'simple_graph/core/error'
require 'simple_graph/core/search'

module SimpleGraph
  module DSL
    class SearchContext

      ALGORITHM_IMPL = {
        dfs: SimpleGraph::Core::Search::DFS,
        bfs: SimpleGraph::Core::Search::BFS
      }

      def self.evaluate(graph, start_at, algorithm:)
        algorithm_impl = ALGORITHM_IMPL[algorithm]

        unless algorithm_impl
          raise SimpleGraph::Core::Error::InvalidSearchAlgorithmError,
                "An unknown algorithm was provided to SearchContext: #{algorithm}"
        end

        vertex_index  = graph.vertices.map.with_index { |v, i| [v, i] }.to_h
        start_index   = start_at.nil? ? 0 : vertex_index[start_at]

        algorithm_impl.new(graph, start_index)
      end
    end
  end
end
