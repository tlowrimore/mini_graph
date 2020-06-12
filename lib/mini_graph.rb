require "mini_graph/version"
require "mini_graph/dsl/graph_context"
require "mini_graph/dsl/search_context"

module MiniGraph

  # Used to construct a new graph.
  #
  # Example usage:
  #
  #   jim   = Person.new
  #   john  = Person.new
  #   jill  = Person.new
  #   jane  = Person.new
  #
  #   friends = MiniGraph.create(jim, john, jill, jane) do
  #     # Creates a directed graph
  #     directed!
  #
  #     edge from: jim,   to: [john, jill, jane]
  #     edge from: john,  to: [jill, jane]
  #     edge from: jane,  to: jill
  #   end
  #
  def self.create(*vertices, &block)
    MiniGraph::DSL::GraphContext.evaluate(*vertices, &block)
  end

  def self.dfs(graph, start_at: nil)
    MiniGraph::DSL::SearchContext.evaluate(graph, start_at, algorithm: :dfs)
  end

  def self.bfs(graph, start_at: nil)
    MiniGraph::DSL::SearchContext.evaluate(graph, start_at, algorithm: :bfs)
  end
end
