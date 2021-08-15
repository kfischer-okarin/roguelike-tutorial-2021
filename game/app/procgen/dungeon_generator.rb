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
      @map_width = map_width
      @map_height = map_height
      @player = player
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
      @corridor_generator = CorridorGenerator.new
      @corridor_generator.rng = rng

      generate
    end

    private

    def generate
      rooms = @rooms_generator.generate
      corridors = @corridor_generator.generate_for(rooms)
      entities = rooms.flat_map { |room| @entities_generator.generate_for(room) }

      builder = DungeonBuilder.new(
        player: @player,
        width: @map_width,
        height: @map_height,
        rooms: rooms,
        corridors: corridors,
        entities: entities
      )

      @result = builder.build
    end
  end
end
