require 'test_helper'

class SimpleGraph::DSL::SearchContextTest < Minitest::Test
  parallelize_me!

  def graph
    @graph ||= SimpleGraph.create(%w(A B C D E F)) do
      directed!

      edge from: 'A',     to: %w(B C D)
      edge from: %w(B C), to: %w(D E F)
    end
  end

  def create_search(graph, start_at, algorithm)
    SimpleGraph::DSL::SearchContext.evaluate(graph, start_at, algorithm: algorithm)
  end

  test '.evaluate raises an error when an invalid algorithm is specified' do
    assert_raises SimpleGraph::Core::Error::InvalidSearchAlgorithmError do
      create_search graph, 'A', :ucc
    end
  end

  test '.evaluate returns an instance of DFS, when algorithm is :dfs' do
    search = create_search graph, 'A', :dfs
    assert_instance_of SimpleGraph::Core::Search::DFS, search
  end

  test '.evaluate returns an instance of BFS, when algorithm is :bfs' do
    search = create_search graph, 'A', :bfs
    assert_instance_of SimpleGraph::Core::Search::BFS, search
  end

  test '.evaluate returns' do

  end
end
