require 'app/procgen/rectangular_room.rb'
require 'app/procgen/dungeon_generator.rb'

module Procgen
  class << self
    def generate_dungeon(parameters:, map_width:, map_height:, player:)
      generator = DungeonGenerator.new(map_width: map_width, map_height: map_height, parameters: parameters, player: player)
      generator.result
    end

    def tunnel_between(start_point, end_point)
      corner = rand < 0.5 ? [end_point.x, start_point.y] : [start_point.x, end_point.y]

      Engine::LineOfSight.bresenham(start_point, corner) + Engine::LineOfSight.bresenham(corner, end_point)
    end
  end
end
