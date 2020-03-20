require 'forwardable'
require 'permissions_graph/error'
require 'permissions_graph/directed_edge'

module PermissionsGraph
  class Digraph

    include Enumerable
    extend  Forwardable

    def_delegators :@vertices, :each, :size, :[]

    # Initialize the graph with a list of vertices
    def initialize(*vertices)
      # copy the vertices to an array to avoid side-effects of mutations made to
      # the original set of vertices

      @vertices = [*vertices].flatten
      @edges    = []
    end

    # Adds an edge from the vertex at origin_index to the vertex at
    # destination_index
    def add_edge(*args)
      edge = args_to_edge(args)

      # origin must reference a valid index within the graph
      if edge.origin >= size
        raise ::PermissionsGraph::Error::InvalidIndexError,
              'origin_index invalid'
      end

      # destination must reference a valid index within the graph
      if edge.destination >= size
        raise ::PermissionsGraph::Error::InvalidIndexError,
              'destination_index invalid'
      end

      # We do not allow self loops
      if edge.self_loop?
        raise ::PermissionsGraph::Error::SelfLoopError,
              'Cannot create a self-looping edge'
      end

      # We do not allow parallel edges
      if connected?(edge)
        raise ::PermissionsGraph::Error::ParallelEdgeError,
              'Edge already exists'
      end

      edges << edge
    end

    # Indicates whether the vertex at origin_index is connected to the vertex
    # at destination_index
    def connected?(*args)
      edge = args_to_edge(args)
      edges.include? edge
    end

    # Returns an array of vertex indices that have an inbound edge from the vertex
    # at the supplied index
    def adjacent_vertices(index)
      edges.reduce([]) do |adj, edge|
        adj << edge.destination if edge.origin == index
        adj
      end
    end

    # Returns a reversed copy of the digraph.
    def reverse
      self.class.new(@vertices).tap do |dg|
        dg.edges = edges.map(&:reverse)
      end
    end

    def to_s
      edges.join
    end

    # -----------------------------------------------------
    # Protected
    # -----------------------------------------------------

    protected

    def edges
      @edges
    end

    def edges=(edges)
      @edges = edges
    end

    # -----------------------------------------------------
    # Private
    # -----------------------------------------------------

    private

    def args_to_edge(args)
      case args.length
      when 1
        args.first
      when 2
        PermissionsGraph::DirectedEdge.new(*args)
      else
        raise ArgumentError,
              "wrong number of arguments.  #{args.length} args were provided. 1 or 2 arguments were expected."
      end
    end
  end
end
