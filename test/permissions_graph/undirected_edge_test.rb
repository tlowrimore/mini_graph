require 'test_helper'

class PermissionsGraph::UndirectedEdgeTest < Minitest::Test
  parallelize_me!

  def create_edge(origin, destination)
    PermissionsGraph::UndirectedEdge.new(origin, destination)
  end

  test '#eql returns true when an edge points from the same origin to the same destination' do
    edge_a  = create_edge(0, 1)
    edge_b  = create_edge(0, 1)

    assert_equal edge_a, edge_b
  end

  test '#eql returns true when compared edges points in opposite directions' do
    edge_a  = create_edge(1, 0)
    edge_b  = create_edge(0, 1)

    assert_equal edge_a, edge_b
  end

  test '#to_s returns a human-friendly string representing the edge' do
    edge = create_edge(1, 3)

    assert_equal "(1 <-> 3)", edge.to_s
  end

  test '#reverse returns a reversed copy of the edge' do
    edge      = create_edge(2, 4)
    reversed  = edge.reverse
    expected  = create_edge(4, 2)

    assert_equal expected, reversed
  end

  test '#self_loop? returns true if the edge points from a vertex X to vertex X' do
    edge  = create_edge(1, 1)

    assert edge.self_loop?
  end

  test '#self_loop returns false if the edge points from a vertex X to vertex Y' do
    edge  = create_edge(1, 3)

    refute edge.self_loop?
  end
end
