module Procgen
  class DungeonGenerator
    class Parameters
      attr_reader :max_rooms, :room_size_range, :max_monsters_per_room

      def initialize(max_rooms:, room_size_range:, max_monsters_per_room:)
        @max_rooms = max_rooms
        @room_size_range = room_size_range
        @max_monsters_per_room = max_monsters_per_room
      end
    end

    attr_reader :result

    def initialize(map_width:, map_height:, parameters:, player:)
      @result = GameMap.new(width: map_width, height: map_height, entities: Entities)
      @parameters = parameters
      @player = player
      @rooms = []

      generate
    end

    private

    def generate
      Entities.add @player

      @parameters.max_rooms.times do
        try_to_generate_room
      end
    end

    def try_to_generate_room
      new_room = build_random_room
      return if existing_room_overlaps? new_room

      if first_room?
        add_player_to_room new_room
      else
        connect_to_previous_room new_room
      end

      place_entities(new_room)

      add_room_to_dungeon new_room
    end

    def build_random_room
      room_width, room_height = rand_room_size

      x = (rand * (@result.width - room_width - 1)).floor
      y = (rand * (@result.height - room_height - 1)).floor

      RectangularRoom.new(x, y, room_width, room_height)
    end

    def rand_room_size
      @room_sizes ||= @parameters.room_size_range.to_a

      [@room_sizes.sample, @room_sizes.sample]
    end

    def existing_room_overlaps?(room)
      @rooms.any? { |existing_room| existing_room.intersects? room }
    end

    def first_room?
      @rooms.empty?
    end

    def add_player_to_room(room)
      @player.x, @player.y = room.center
    end

    def connect_to_previous_room(room)
      Procgen.tunnel_between(@rooms[-1].center, room.center).each do |tunnel_x, tunnel_y|
        @result.set_tile(tunnel_x, tunnel_y, Tiles.floor)
      end
    end

    def place_entities(room)
      random_number_of_monsters.times do
        x = room.x + 1 + (rand * (room.w - 2)).floor
        y = room.y + 1 + (rand * (room.h - 2)).floor
        next if @result.entity_at?(x, y)

        if rand < 0.8
          @result.add_entity Entity.build(:mutant_spider, x: x, y: y)
        else
          @result.add_entity Entity.build(:cyborg_bearman, x: x, y: y)
        end
      end
    end

    def random_number_of_monsters
      @possible_monster_numbers ||= (0..@parameters.max_monsters_per_room).to_a
      @possible_monster_numbers.sample
    end

    def add_room_to_dungeon(room)
      @result.fill_rect(room.inner_rect, Tiles.floor)
      @rooms << room
    end
  end
end