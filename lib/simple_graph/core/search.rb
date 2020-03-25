module SimpleGraph
  module Core
    module Search

      # -----------------------------------------------------
      # Base Search Implementation
      # -----------------------------------------------------

      class Base
        include Enumerable

        attr_reader :graph, :vertex_index

        def initialize(graph, vertex_index)
          @graph        = graph
          @vertex_index = vertex_index
        end

        def each
          visit(vertex_index) do |vi|
            yield graph[vi]
          end
        end

        def visit(index, visited=Array.new(graph.size, false), &block)
          raise NotImplementedError, "#visit must be implemented"
        end
      end

      # -----------------------------------------------------
      # Depth-First Search
      # -----------------------------------------------------

      class DFS < Base
        def visit(index, visited=Array.new(graph.size, false), &block)
          visited[index] = true
          yield index

          graph.adjacent_vertices(index).each do |vi|
            visit(vi, visited, &block) unless visited[vi]
          end
        end
      end

      # -----------------------------------------------------
      # Breadth-First Search
      # -----------------------------------------------------

      class BFS < Base
        def visit(index, visited=Array.new(graph.size, false), &block)
          queue           = []
          visited[index]  = true

          queue.push(index)

          while !queue.empty?
            next_index = queue.shift
            yield next_index

            graph.adjacent_vertices(next_index).each do |vi|
              unless visited[vi]
                visited[vi] = true
                queue.push(vi)
              end
            end
          end
        end
      end
    end
  end
end
