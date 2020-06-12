require 'test_helper'

class MiniGraph::DSL::GraphContextTest < Minitest::Test
  parallelize_me!

  def create_graph(*vertices, &block)
    MiniGraph::DSL::GraphContext.evaluate(*vertices, &block)
  end

  test '.evaluate raises an error if no block is provided' do
    assert_raises ArgumentError do
      create_graph(1, 2, 3)
    end
  end

  test '.evaluate creates a new graph when vertices are separate arguments and a block is provided' do
    graph = create_graph('a', 'b', 'c') do
      edge from: 'a', to: 'b'
    end

    assert_equal %w(a b c), graph.vertices
  end

  test '.evaluate creates a new graph when vertices are provided as a single argument and a block is provided' do
    graph = create_graph(%w(a b c)) do
      edge from: 'a', to: 'b'
    end

    assert_equal %w(a b c), graph.vertices
  end

  test '.evaluate creates an undirected graph by default' do
    graph = create_graph(%w(a b c)) do
      edge from: 'a', to: 'b'
    end

    assert graph.undirected?
  end

  test '.evaluate creates a directed graph when the directed! directive is used' do
    graph = create_graph(%w(a b c)) do
      directed!
      edge from: 'a', to: 'b'
    end

    assert graph.directed?
  end

  test '.evaluate raises an error when an invalid edge is specified' do
    assert_raises MiniGraph::Core::Error::InvalidEdgeError do
      create_graph(%w(a b c)) do
        edge from: 'a', to: 'z'
      end
    end
  end

  test '.evaluate allows for one-to-one edges to be defined' do
    vertices      = %w(a b c)
    vertex_index  = vertices.map.with_index { |v, i| [v, i] }.to_h

    graph = create_graph(vertices) do
      edge from: 'a', to: 'b'
    end

    expected  = [vertex_index['b']]
    actual    = graph.adjacent_vertices(vertex_index['a'])

    assert_equal expected, actual
  end

  test '.evaluate allows for one-to-many edges to be defined' do
    vertices      = %w(a b c)
    vertex_index  = vertices.map.with_index { |v, i| [v, i] }.to_h

    graph = create_graph(vertices) do
      edge from: 'a', to: ['b', 'c']
    end

    expected  = vertex_index.values_at('b', 'c')
    actual    = graph.adjacent_vertices(vertex_index['a'])

    assert_equal expected, actual
  end

  test '.evaluate allows for many-to-many edges to be defined' do
    vertices      = %w(a b c)
    vertex_index  = vertices.map.with_index { |v, i| [v, i] }.to_h

    graph = create_graph(vertices) do
      directed!
      edge from: ['a', 'b'], to: ['b', 'c']
    end

    expected  = vertex_index.values_at('b', 'c') + vertex_index.values_at('b', 'c')
    actual    = graph.adjacent_vertices(vertex_index['a']) +
                graph.adjacent_vertices(vertex_index['b'])

    assert_equal expected, actual
  end
end
