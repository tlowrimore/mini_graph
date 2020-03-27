require "test_helper"

class SimpleGraphTest < Minitest::Test
  test '.create creates a new graph' do
    graph = SimpleGraph.create %w(A B C D) do
      directed!
      edge from: 'A', to: ['B','C','D']
    end

    assert_equal [1,2,3], graph.adjacent_vertices(0)
  end

  test '.dfs creates a new depth-first search' do
    graph   = SimpleGraph.create %w(D E F) do
      undirected!
      edge from: %w(D E F), to: %w(D E F)
    end

    search  = SimpleGraph.dfs(graph, start_at: 'D')

    assert_instance_of SimpleGraph::Core::Search::DFS, search
  end

  test '.bfs creates a new breadth-first search' do
    graph   = SimpleGraph.create %w(D E F) do
      directed!
      edge from: %w(D E F), to: %w(D E F)
    end

    search  = SimpleGraph.bfs(graph, start_at: 'D')
    
    assert_instance_of SimpleGraph::Core::Search::BFS, search
  end
end
