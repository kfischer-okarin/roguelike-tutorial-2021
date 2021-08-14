module Procgen
  class DungeonGenerator
    class Parameters < DataBackedObject
      data_reader :max_rooms, :min_room_size, :max_room_size, :max_monsters_per_room, :max_items_per_room

      def initialize(data)
        super()
        @data = data
        require_data_keys! %i[
          max_rooms
          min_room_size
          max_room_size
          max_monsters_per_room
          max_items_per_room
        ]
      end

      def room_size_range
        (min_room_size..max_room_size)
      end
    end

    attr_reader :result

    def initialize(map_width:, map_height:, parameters:, player:)
      @result = GameMap.new(
        width: map_width,
        height: map_height,
        tiles: Array.new(map_width * map_height) { :wall },
        explored: Array.new(map_width * map_height) { false }
      )
      @parameters = parameters
      @player = player
      @rooms = []
      rng = RNG.new
      @entities_generator = RoomEntitiesGenerator.new(
        max_monsters_per_room: parameters.max_monsters_per_room,
        max_items_per_room: parameters.max_items_per_room
      )
      @entities_generator.rng = rng
      @rooms_generator = RoomsGenerator.new(
        map_width: map_width,
        map_height: map_height,
        max_rooms: parameters.max_rooms,
        min_size: parameters.min_room_size,
        max_size: parameters.max_room_size
      )
      @rooms_generator.rng = rng

      generate
    end

    private

    def generate
      @rooms = @rooms_generator.generate

      add_player_to_room @rooms.first

      @rooms.each do |room|
        construct_room room
      end

      (1..(@rooms.size - 1)).each do |index|
        connect_rooms @rooms[index - 1], @rooms[index]
      end

      @result.calculate_tiles
    end

    def add_player_to_room(room)
      room_center = room.center
      @player.place(@result, x: room_center.x, y: room_center.y)
    end

    def construct_room(room)
      place_entities(room)

      add_room_to_dungeon room
    end

    def connect_rooms(room1, room2)
      Procgen.tunnel_between(room1.center, room2.center).each do |tunnel_x, tunnel_y|
        @result.set_tile tunnel_x, tunnel_y, :floor
      end
    end

    def place_entities(room)
      @entities_generator.generate_for(room).each do |entity|
        next if @result.entity_at?(entity[:x], entity[:y])

        EntityPrototypes.build(entity[:type]).place(@result, x: entity[:x], y: entity[:y])
      end
    end

    def add_room_to_dungeon(room)
      @result.fill_rect room.inner_rect, :floor
    end
  end
end
