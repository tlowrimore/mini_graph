require 'simple_graph/core/graph'

module SimpleGraph
  module DSL
    class GraphContext
      def self.create(*vertices, &block)
        unless block_given?
          raise ArgumentError, "cannot call .create without a block"
        end
        
        graph_context = new(vertices)
        graph_context.instance_eval(&block)
        graph_context.resolve
      end

      # -----------------------------------------------------
      # Public Methods
      # -----------------------------------------------------

      def resolve
        SimpleGraph::Core::Graph.new(@vertices, directed: @directed).tap do |g|
          @edges.each do |edge|
            g.add_edge(*edge)
          end
        end
      end

      # -----------------------------------------------------
      # Protected Methods
      # -----------------------------------------------------

      protected

      attr_reader :vertex_index

      def initialize(vertices)
        @vertices     = [vertices].flatten
        @vertex_index = @vertices.map.with_index { |v, i| [v, i] }.to_h
        @directed     = false
        @edges        = []
      end

      def undirected!
        @directed = false
      end

      def directed!
        @directed = true
      end

      def edge(from:, to:)
        from_indices  = vertices_to_indices(from)
        to_indices    = vertices_to_indices(to)

        @edges += from_indices.flat_map do |origin|
          to_indices.map do |destination|
            [origin, destination]
          end
        end
      end

      # -----------------------------------------------------
      # Private Methods
      # -----------------------------------------------------

      private

      def vertices_to_indices(vertices)
        [vertices].flatten.map { |v| vertex_index[v] }
      end
    end
  end
end
