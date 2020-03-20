require 'permissions_graph/directed_edge'

module PermissionsGraph
  class UndirectedEdge < PermissionsGraph::DirectedEdge
    def eql?(edge)
      super || (origin == edge.destination && destination == edge.origin)
    end

    def to_s
      "(#{origin} <-> #{destination})"
    end
  end
end
