require 'test_helper'

class PermissionsGraph::DigraphTest < Minitest::Test
  parallelize_me!

  def create_graph(*vertices)
    PermissionsGraph::Digraph.new(*vertices)
  end

  test '#initialize with no vertices when an argument is not provided' do
    graph = create_graph
    assert_empty graph.entries
  end

  test '#initialize with vertices when initialized with individual args' do
    graph = create_graph 1,2,3,4,5
    assert_equal [1,2,3,4,5], graph.entries
  end

  test '#initialize with vertices when initialized with an array of vertices' do
    graph = create_graph [1,2,3,4,5]
    assert_equal [1,2,3,4,5], graph.entries
  end

  test '#add_edge raises an error if origin index exceeds the bounds of the graph vertices' do
    graph = create_graph [1,2,3,4,5]

    assert_raises PermissionsGraph::Error::InvalidIndexError do
      graph.add_edge(5, 0)
    end
  end

  test '#add_edge raises an error if destination index exceeds the bounds of the graph vertices' do
    graph = create_graph [1,2,3,4,5]
    assert_raises PermissionsGraph::Error::InvalidIndexError do
      graph.add_edge(0, 5)
    end
  end

  test '#add_edge raises an error when a self looping edge is added' do
    graph = create_graph [1,2,3,4,5]
    assert_raises PermissionsGraph::Error::SelfLoopError do
      graph.add_edge(1, 1)
    end
  end

  test '#add_edge raises an error when a parallel edge is added' do
    graph = create_graph [1,2,3,4,5]
    graph.add_edge(1,4)

    assert_raises PermissionsGraph::Error::ParallelEdgeError do
      graph.add_edge(1,4)
    end
  end

  test '#add_edge creates an edge between two vertices' do
    graph = create_graph 1,2,3,4,5

    graph.add_edge(2,3)
    graph.add_edge(2,4)

    assert_equal "(2 -> 3)(2 -> 4)", graph.to_s
  end

  test '#add_edge allows instances of PermissionsGraph::Edge to be added' do
    graph = create_graph 1,2,3,4,5
    edge  = PermissionsGraph::DirectedEdge.new(2,3)
    graph.add_edge(edge)

    assert_equal "(2 -> 3)", graph.to_s
  end

  test '#connected? returns true when provided an origin and destination index for two connected vertices' do
    graph = create_graph 1,2,3,4,5
    graph.add_edge(2,3)

    assert graph.connected?(2,3)
  end

  test '#connected? returns false when provided an origin and destination index for two disconnected vertices' do
    graph = create_graph 1,2,3,4,5
    graph.add_edge(0,4)

    refute graph.connected?(2,3)
  end

  test '#connected? returns true when provided an edge for two connected vertices' do
    graph = create_graph 1,2,3,4,5
    edge  = PermissionsGraph::DirectedEdge.new(0,4)

    graph.add_edge(0,4)

    assert graph.connected?(edge)
  end

  test '#connected? returns false when provided an edge for two disconnected vertices' do
    graph = create_graph 1,2,3,4,5
    edge  = PermissionsGraph::DirectedEdge.new(2,3)

    graph.add_edge(0,4)

    refute graph.connected?(edge)
  end

  test '#connected? raises an error when provided invalid args' do
    graph = create_graph 1,2,3,4,5

    assert_raises ArgumentError do
      graph.add_edge(0,2,4)
    end
  end

  test '#adjacent_vertices returns an empty array when a vertex has no outbound connections to other vertices' do
    graph = create_graph 1,2,3,4,5

    assert_empty graph.adjacent_vertices(2)
  end

  test '#adjacent_vertices returns an empty array when a vertex has only inbound connections to other vertices' do
    graph = create_graph 1,2,3,4,5
    graph.add_edge(0, 2)
    graph.add_edge(4, 2)

    assert_empty graph.adjacent_vertices(2)
  end

  test '#adjacent_vertices returns an array of vertex indices when a vertex has outbound connections to other vertices' do
    graph = create_graph 1,2,3,4,5
    graph.add_edge(2, 0)
    graph.add_edge(2, 4)

    assert_equal [0,4], graph.adjacent_vertices(2)
  end

  test '#reverse returns a new Digraph with all edges reversed' do
    graph = create_graph 1,2,3,4,5

    graph.add_edge(2, 0)
    graph.add_edge(2, 4)

    reversed = graph.reverse

    assert_equal "(0 -> 2)(4 -> 2)", reversed.to_s
  end
end
