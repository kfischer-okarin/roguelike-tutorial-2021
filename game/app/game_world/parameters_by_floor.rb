class GameWorld < DataBackedObject
  class ParametersByFloor
    class ValuesByFloor
      def initialize(values)
        @values = values
      end

      def value_for_floor(floor)
        key = @values.keys.select { |from_floor| from_floor <= floor }.max
        @values[key]
      end
    end

    def initialize(max_items_per_room:, max_monsters_per_room:)
      @max_items_per_room = ValuesByFloor.new(max_items_per_room)
      @max_monsters_per_room = ValuesByFloor.new(max_monsters_per_room)
    end

    def for_floor(floor)
      Procgen::DungeonGenerator::Parameters.new(
        max_rooms: 10,
        min_room_size: 6,
        max_room_size: 10,
        max_monsters_per_room: @max_monsters_per_room.value_for_floor(floor),
        max_items_per_room: @max_items_per_room.value_for_floor(floor)
      )
    end
  end
end
