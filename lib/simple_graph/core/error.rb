module SimpleGraph
  module Core
    module Error
      class GraphError < StandardError; end

      class SelfLoopError < GraphError; end
      class ParallelEdgeError < GraphError; end
      class InvalidIndexError < GraphError; end
      class InvalidEdgeError < GraphError; end
      class InvalidEdgeTypeError < GraphError; end
    end
  end
end
