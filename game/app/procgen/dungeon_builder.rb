module Procgen
  class DungeonBuilder
    def initialize(player:, width:, height:, rooms:, corridors:, entities:)
      @player = player
      @width = width
      @height = height
      @rooms = rooms
      @corridors = corridors
      @entities = entities
    end

    def build
      GameMap.new(width: @width, height: @height).tap { |result|
        place_rooms result
        place_corridors result
        place_player_in_first_room result
        place_entities result
        result.calculate_tiles
      }
    end

    private

    def place_rooms(game_map)
      @rooms.each do |room|
        place_room game_map, room
      end
    end

    def place_room(game_map, room)
      game_map.fill_rect room.inner_rect, :floor
    end

    def place_corridors(game_map)
      @corridors.each do |corridor|
        place_corridor game_map, corridor
      end
    end

    def place_corridor(game_map, corridor)
      Engine::LineOfSight.bresenham(corridor.from, corridor.to).each do |tunnel_x, tunnel_y|
        game_map.set_tile tunnel_x, tunnel_y, :floor
      end
    end

    def place_player_in_first_room(game_map)
      first_room_center = @rooms.first.center
      @player.place(game_map, x: first_room_center.x, y: first_room_center.y)
    end

    def place_entities(game_map)
      @entities.each do |entity|
        next if game_map.entity_at?(entity[:x], entity[:y])

        EntityPrototypes.build(entity[:type]).place(game_map, x: entity[:x], y: entity[:y])
      end
    end
  end
end
