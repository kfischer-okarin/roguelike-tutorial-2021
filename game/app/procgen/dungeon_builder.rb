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
      GameMap.new(
        width: @width,
        height: @height,
        tiles: build_tiles,
        portal_location: portal_location
      ).tap { |result|
        place_player_in_first_room result
        place_entities result
        result.calculate_tiles
      }
    end

    private

    def build_tiles
      (Array.new(@width * @height) { :wall }).tap { |result|
        tiles_2d = Array2D.new(@width, @height, result)
        place_rooms tiles_2d
        place_corridors tiles_2d
        tiles_2d[portal_location.x, portal_location.y] = :portal
      }
    end

    def portal_location
      @portal_location ||= @rooms.last.center
    end

    def place_rooms(tiles_2d)
      @rooms.each do |room|
        place_room tiles_2d, room
      end
    end

    def place_room(tiles_2d, room)
      tiles_2d.fill_rect room.inner_rect, :floor
    end

    def place_corridors(tiles_2d)
      @corridors.each do |corridor|
        place_corridor tiles_2d, corridor
      end
    end

    def place_corridor(tiles_2d, corridor)
      Engine::LineOfSight.bresenham(corridor.from, corridor.to).each do |tunnel_x, tunnel_y|
        tiles_2d[tunnel_x, tunnel_y] = :floor
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
