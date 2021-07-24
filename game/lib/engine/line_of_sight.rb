module Engine
  module LineOfSight
    class << self
      def bresenham(start_point, end_point)
        [].tap { |result|
          x = start_point.x
          y = start_point.y
          end_x = end_point.x
          end_y = end_point.y

          dx = (end_x - x).abs
          sx = x < end_x ? 1 : -1
          dy = -(end_y - y).abs
          sy = y < end_y ? 1 : -1
          err = dx + dy

          loop do
            result << [x, y]
            break if x == end_x && y == end_y

            e2 = 2 * err
            if e2 > dy
              err += dy
              x += sx
            elsif e2 <= dx
              err += dx
              y += sy
            end
          end
        }
      end
    end
  end
end
