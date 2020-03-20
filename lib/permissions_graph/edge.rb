require 'permissions_graph/error'

module PermissionsGraph
  class Edge
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

    def reverse
      self.class.new(destination, origin)
    end

    def self_loop?
      origin == destination
    end
  end
end
