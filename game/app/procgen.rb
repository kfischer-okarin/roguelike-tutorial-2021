require 'app/procgen/rectangular_room.rb'
require 'app/procgen/corridor.rb'
require 'app/procgen/generator.rb'
require 'app/procgen/room_entities_generator.rb'
require 'app/procgen/rooms_generator.rb'
require 'app/procgen/corridor_generator.rb'
require 'app/procgen/dungeon_builder.rb'
require 'app/procgen/dungeon_generator.rb'

module Procgen
  class << self
    def generate_dungeon(parameters:, map_width:, map_height:, player:, seed:)
      generator = DungeonGenerator.new(
        map_width: map_width,
        map_height: map_height,
        parameters: parameters,
        player: player,
        seed: seed
      )
      generator.result
    end
  end
end
