module Components
  module AI
    class Graph
      def initialize(game_map)
        @game_map = game_map
        @w = game_map.width
        @h = game_map.height
      end

      def neighbors_of(position)
        x, y = position
        is_bottom = y.zero?
        is_top = y == @h - 1
        Enumerator.new do |yielder|
          unless x.zero?
            yielder << [x - 1, y + 1] unless is_top
            yielder << [x - 1, y]
            yielder << [x - 1, y - 1] unless is_bottom
          end
          unless x == @w - 1
            yielder << [x + 1, y + 1] unless is_top
            yielder << [x + 1, y]
            yielder << [x + 1, y - 1] unless is_bottom
          end
          yielder << [x, y + 1] unless is_top
          yielder << [x, y - 1] unless is_bottom
        end
      end

      def cost(from, to)
        return 0 unless @game_map.walkable?(to.x, to.y)

        base_cost = 1
        base_cost += 10 if @game_map.entity_at?(to.x, to.y)
        cost_factor = diagonal?(from, to) ? 3 : 2
        base_cost * cost_factor
      end

      def diagonal?(from, to)
        !(to.x - from.x).zero? && !(to.y - from.y).zero?
      end
    end
  end
end
