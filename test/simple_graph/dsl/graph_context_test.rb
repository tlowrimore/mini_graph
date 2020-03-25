require 'test_helper'

class SimpleGraph::DSL::GraphContextTest < Minitest::Test
  def create_graph_context(*vertices, &block)
    SimpleGraph::DSL::GraphContext.create(*vertices, &block)
  end

  test '.create raises an error if no block is provided' do
    assert_raises ArgumentError do
      create_graph_context(1, 2, 3)
    end
  end

  test '.create creates a new graph when vertices are separate arguments and a block is provided' do
    graph = create_graph_context('a', 'b', 'c') do
      directed!
      edge from: 'a', to: 'b'
    end

    assert_equal %w(a b c), graph.entries
  end

  test '.create creates a new graph when vertices are provided as a single argument and a block is provided' do
    graph = create_graph_context(%w(a b c)) do
      directed!
      edge from: 'a', to: 'b'
    end

    assert_equal %w(a b c), graph.entries
  end
end
