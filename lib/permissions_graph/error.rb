module PermissionsGraph
  module Error
    class GraphError < StandardError; end

    class SelfLoopError < GraphError; end
    class ParallelEdgeError < GraphError; end
    class InvalidIndexError < GraphError; end
    class InvalidEdgeType < GraphError; end
  end
end
