require 'lib/engine/field_of_view/line_of_sight_4e.rb'

module Engine
  module FieldOfView
    def self.calculate_line_of_sight_4e(transparency_map:, x:, y:, radius:)
      map_adapter = MapAdapter.new(transparency_map: transparency_map, x: x, y: y, radius: radius)
      fov = LineOfSight4e.new(map_adapter)
      fov.calculate(from: [radius, radius])
      result = Array2D.new(transparency_map.w, transparency_map.h) { false }
      map_adapter.each_coordinate do |map_x, map_y|
        result[map_x, map_y] = fov.visible?(map_x - map_adapter.fov_x, map_y - map_adapter.fov_y)
      end
      result
    end

    class MapAdapter
      attr_reader :fov_x, :fov_y, :fov_w, :fov_h

      def initialize(transparency_map:, x:, y:, radius:)
        @transparency_map = transparency_map
        @x = x
        @y = y
        @radius = radius


        @fov_x = x - radius
        @fov_y = y - radius
        @fov_w = radius * 2 + 1
        @fov_h = radius * 2 + 1
      end

      def size
        [@fov_w, @fov_h]
      end

      def each_coordinate
        (@fov_x...(@fov_x + @fov_w)).each do |x|
          (@fov_y...(@fov_y + @fov_h)).each do |y|
            yield x, y
          end
        end
      end

      def obstacles
        obstacles = [].tap { |result|
          each_coordinate do |x, y|
            next if @transparency_map[x, y]

            result << [x - @fov_x, y - @fov_y, 1, 1]
          end
        }
        merge_obstacles obstacles
      end

      def merge_obstacles(obstacles)
        [].tap { |result|
          by_x = {}
          by_y = {}
          obstacles.each do |obstacle|
            by_x[obstacle.x] ||= []
            by_x[obstacle.x] << obstacle
            by_y[obstacle.y] ||= []
            by_y[obstacle.y] << obstacle
          end
          by_x.each_value do |current_x_obstacles|
            current_x_obstacles.sort_by(&:y)
            next_obstacle = current_x_obstacles[0].dup
            current_x_obstacles[1..-1].each do |obstacle|
              if obstacle.y == next_obstacle.y + next_obstacle.h
                next_obstacle.h += 1
              else
                result << next_obstacle
                next_obstacle = obstacle.dup
              end
            end
            result << next_obstacle
          end

          by_y.each_value do |current_y_obstacles|
            current_y_obstacles.sort_by(&:x)
            next_obstacle = current_y_obstacles[0].dup
            current_y_obstacles[1..-1].each do |obstacle|
              if obstacle.x == next_obstacle.x + next_obstacle.w
                next_obstacle.w += 1
              else
                result << next_obstacle
                next_obstacle = obstacle.dup
              end
            end
            result << next_obstacle
          end
        }
      end
    end
  end
end
