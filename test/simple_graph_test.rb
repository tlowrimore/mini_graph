require "test_helper"

class SimpleGraphTest < Minitest::Test
  test '.create creates a new graph' do
    graph = SimpleGraph.create %w(A B C D) do
      directed!
      edge from: 'A', to: ['B','C','D']
    end

    assert_equal [1,2,3], graph.adjacent_vertices(0)
  end
end
