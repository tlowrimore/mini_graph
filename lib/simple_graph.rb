require "simple_graph/version"
require "simple_graph/dsl/graph_context"

module SimpleGraph

  # Used to construct a new graph.
  #
  # Example usage:
  #
  #   jim   = Person.new
  #   john  = Person.new
  #   jill  = Person.new
  #   jane  = Person.new
  #
  #   friends = SimpleGraph.create(jim, john, jill, jane) do
  #     # Creates a directed graph
  #     directed!
  #
  #     edge from: jim,   to: [john, jill, jane]
  #     edge from: john,  to: [jill, jane]
  #     edge from: jane,  to: jill
  #   end
  #
  def self.create(*vertices, &block)
    SimpleGraph::DSL::GraphContext.create(*vertices, &block)
  end
end
