require 'app/procgen/rectangular_room.rb'

module Procgen
  class << self
    def generate_dungeon(map_width, map_height)
      GameMap.new(width: map_width, height: map_height).tap { |dungeon|
        room1 = RectangularRoom.new(x: 20, y: 15, width: 10, height: 15)
        room2 = RectangularRoom.new(x: 35, y: 15, width: 10, height: 15)

        dungeon.fill_rect(room1.inner_rect, Tiles.floor)
        dungeon.fill_rect(room2.inner_rect, Tiles.floor)
      }
    end
  end
end
