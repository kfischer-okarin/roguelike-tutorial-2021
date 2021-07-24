require 'app/procgen/rectangular_room.rb'

module Procgen
  class << self
    def generate_dungeon(map_width, map_height)
      GameMap.new(width: map_width, height: map_height).tap { |dungeon|
        room1 = RectangularRoom.new(x: 20, y: 15, width: 10, height: 15)
        room2 = RectangularRoom.new(x: 35, y: 15, width: 10, height: 15)

        dungeon.fill_rect(room1.inner_rect, Tiles.floor)
        dungeon.fill_rect(room2.inner_rect, Tiles.floor)

        tunnel_between(room2.center, room1.center).each do |x, y|
          dungeon.set_tile(x, y, Tiles.floor)
        end
      }
    end

    def tunnel_between(start_point, end_point)
      corner = rand < 0.5 ? [end_point.x, start_point.y] : [start_point.x, end_point.y]

      Engine::LineOfSight.bresenham(start_point, corner) + Engine::LineOfSight.bresenham(corner, end_point)
    end
  end
end
