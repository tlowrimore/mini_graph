require 'mini_graph/core/error'

module MiniGraph
  module Core
    module Edge

      # -----------------------------------------------------
      # Directed Edge
      # -----------------------------------------------------

      class Directed
        attr_reader :origin, :destination

        def initialize(origin, destination)
          @origin       = origin
          @destination  = destination
        end

        def eql?(edge)
          origin == edge.origin && destination == edge.destination
        end

        # cannot use alias or alias_method for this, as subclasses (e.g. UndirectedEdge)
        # do not behave as expected.  We'll be explicit.
        def ==(edge)
          eql?(edge)
        end

        def to_s
          "(#{origin} -> #{destination})"
        end

        # Another case of not using alias to allow subclasses to behave as expected.
        def inspect
          to_s
        end

        # Reverses the direction of the edge
        def reverse
          self.class.new(destination, origin)
        end

        # Indicates a self-looping edge; i.e., an edge that connects a vertex to
        # itself.
        def self_loop?
          origin == destination
        end
      end

      # -----------------------------------------------------
      # Undirected
      # -----------------------------------------------------

      class Undirected < Directed
        def eql?(edge)
          super || (origin == edge.destination && destination == edge.origin)
        end

        def to_s
          "(#{origin} <-> #{destination})"
        end
      end
    end
  end
end
