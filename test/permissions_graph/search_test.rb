require 'test_helper'
require 'permissions_graph'
require 'permissions_graph/search'

class PermissionsGraph::SearchTest < Minitest::Test
  parallelize_me!

  def directed_graph
    vertices = %w(A B C D E F G)
    @directed_graph ||= PermissionsGraph::Graph.new(vertices, directed: true).tap do |g|
      g.add_edge(0, 1)
      g.add_edge(0, 2)
      g.add_edge(1, 3)
      g.add_edge(2, 4)
      g.add_edge(4, 3)
      g.add_edge(2, 5)
      g.add_edge(5, 6)
      g.add_edge(6, 4)
    end
  end

  def undirected_graph
    vertices = %w(A B C D E F G)
    @undirected_graph ||= PermissionsGraph::Graph.new(vertices).tap do |g|
      g.add_edge(0, 1)
      g.add_edge(0, 2)
      g.add_edge(1, 2)
      g.add_edge(1, 3)
      g.add_edge(2, 4)
      g.add_edge(3, 6)
      g.add_edge(4, 5)
      g.add_edge(5, 6)
    end
  end

  test 'DFS on directed graph, starting at the root vertex will traverse the entire graph' do
    dfs = PermissionsGraph::Search::DFS.new(directed_graph, 0)
    assert_equal %w(A B D C E F G), dfs.entries
  end

  test 'DFS on directed_graph, starting at a vertex with one out-edge to a vertex with no out-edges will contain only two vertices' do
    dfs = PermissionsGraph::Search::DFS.new(directed_graph, 4)
    assert_equal %w(E D), dfs.entries
  end

  test 'DFS on a directed_graph, starting at a vertex with only in-edges will return only the starting vertex' do
    inverted_directed_graph = directed_graph.reverse
    dfs = PermissionsGraph::Search::DFS.new(inverted_directed_graph, 0)
    assert_equal %w(A), dfs.entries
  end

  test 'DFS on an undirected graph, starting at the root vertex will traverse the entire graph' do
    dfs = PermissionsGraph::Search::DFS.new(undirected_graph, 0)
    assert_equal %w(A B C E F G D), dfs.entries
  end

  test 'DFS on an undirected graph, starting from a "middle" vertex will traverse the entire graph' do
    dfs = PermissionsGraph::Search::DFS.new(undirected_graph, 4)
    assert_equal %w(E C A B D G F), dfs.entries
  end

  test 'BFS on a directed graph, starting at the root vertex will traverse the entire graph' do
    bfs = PermissionsGraph::Search::BFS.new(directed_graph, 0)
    assert_equal %w(A B C D E F G), bfs.entries
  end

  test 'BFS on a directed graph, starting at a vertex with one out-edge to a vertex with no out-edges will contain only two vertices' do
    bfs = PermissionsGraph::Search::BFS.new(directed_graph, 4)
    assert_equal %w(E D), bfs.entries
  end

  test 'BFS on a directed_graph, starting at a vertex with only in-edges will return only the starting vertex' do
    inverted_directed_graph = directed_graph.reverse
    bfs = PermissionsGraph::Search::BFS.new(inverted_directed_graph, 0)
    assert_equal %w(A), bfs.entries
  end

  test 'BFS on an undirected graph, starting at the root vertex will traverse the entire graph' do
    bfs = PermissionsGraph::Search::BFS.new(undirected_graph, 0)
    assert_equal %w(A B C D E G F), bfs.entries
  end

  test 'BFS on an undirected graph, starting from a "middle" vertex will traverse the entire graph' do
    bfs = PermissionsGraph::Search::BFS.new(undirected_graph, 4)
    assert_equal %w(E C F A B G D), bfs.entries
  end
end
