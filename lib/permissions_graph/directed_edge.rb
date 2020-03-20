require 'permissions_graph/error'

module PermissionsGraph
  class DirectedEdge
    attr_reader :origin, :destination

    def initialize(origin, destination)
      @origin       = origin
      @destination  = destination
    end

    def eql?(edge)
      origin == edge.origin && destination == edge.destination
    end

    alias == eql?

    def to_s
      "(#{origin} -> #{destination})"
    end

    alias inspect to_s

    # Reverses the direction of the edge
    def reverse
      self.class.new(destination, origin)
    end

    # Indicates a self-looping edge; i.e., an edge that connects a vertex to
    # itself.
    def self_loop?
      origin == destination
    end
  end
end
