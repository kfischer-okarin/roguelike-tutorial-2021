require 'app/procgen/rectangular_room.rb'

module Procgen
  class << self
    def generate_dungeon(max_rooms:, room_min_size:, room_max_size:, map_width:, map_height:, player:)
      Entities.add player

      GameMap.new(width: map_width, height: map_height, entities: Entities).tap { |dungeon|
        rooms = []
        room_sizes = (room_min_size..room_max_size).to_a
        max_rooms.times do
          room_width = room_sizes.sample
          room_height = room_sizes.sample

          x = (rand * (dungeon.width - room_width - 1)).floor
          y = (rand * (dungeon.height - room_height - 1)).floor

          new_room = RectangularRoom.new(x, y, room_width, room_height)
          next if rooms.any? { |room| room.intersects? new_room }

          dungeon.fill_rect(new_room.inner_rect, Tiles.floor)

          if rooms.empty?
            player.x, player.y = new_room.center
          else
            tunnel_between(rooms[-1].center, new_room.center).each do |tunnel_x, tunnel_y|
              dungeon.set_tile(tunnel_x, tunnel_y, Tiles.floor)
            end
          end

          rooms << new_room
        end
      }
    end

    def tunnel_between(start_point, end_point)
      corner = rand < 0.5 ? [end_point.x, start_point.y] : [start_point.x, end_point.y]

      Engine::LineOfSight.bresenham(start_point, corner) + Engine::LineOfSight.bresenham(corner, end_point)
    end
  end
end
