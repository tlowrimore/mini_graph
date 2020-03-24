require 'forwardable'
require 'permissions_graph/edge'
require 'permissions_graph/error'

module PermissionsGraph
  class Graph

    include Enumerable
    extend  Forwardable

    def_delegators :@vertices, :each, :size, :[]

    # Initialize a directed or undirected graph with a list of vertices
    def initialize(vertices, directed: false)
      @directed = !!directed
      @vertices = [*vertices].flatten
      @edges    = []
    end

    def edge_class
      if directed?
        PermissionsGraph::Edge::Directed
      else
        PermissionsGraph::Edge::Undirected
      end
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

      edges << edge
    end

    def directed?
      @directed
    end

    def undirected?
      !directed?
    end

    # Returns an array of vertex indices that have an inbound edge from the vertex
    # at the supplied index
    def adjacent_vertices(index)
      edges.reduce([]) do |adj, edge|
        adj << edge.destination if edge.origin == index
        adj << edge.origin      if undirected? && edge.destination == index
        adj
      end
      .uniq
    end

    # Returns a reversed copy of the digraph.
    def reverse
      self.class.new(@vertices, directed: @directed).tap do |dg|
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
        args.first.tap do |edge|
          if edge.class != edge_class
            raise PermissionsGraph::Error::InvalidEdgeType,
                  "edge must be instance of #{edge_class.name}"
          end
        end
      when 2
        edge_class.new(*args)
      else
        raise ArgumentError,
              "wrong number of arguments.  #{args.length} args were provided. 1 or 2 arguments were expected."
      end
    end
  end
end
