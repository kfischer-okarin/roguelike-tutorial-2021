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

      def self.from_incremental_hashes(hashes)
        values = {}
        value_so_far = {}
        hashes.keys.sort.each do |floor|
          value_so_far = value_so_far.merge(hashes[floor])
          values[floor] = value_so_far
        end
        new values
      end
    end

    def initialize(max_items_per_room:, max_monsters_per_room:, item_weights:, monster_weights:)
      @max_items_per_room = ValuesByFloor.new(max_items_per_room)
      @max_monsters_per_room = ValuesByFloor.new(max_monsters_per_room)
      @item_weights = ValuesByFloor.from_incremental_hashes(item_weights)
      @monster_weights = ValuesByFloor.from_incremental_hashes(monster_weights)
    end

    def for_floor(floor)
      Procgen::DungeonGenerator::Parameters.new(
        max_rooms: 10,
        min_room_size: 6,
        max_room_size: 10,
        max_monsters_per_room: @max_monsters_per_room.value_for_floor(floor),
        max_items_per_room: @max_items_per_room.value_for_floor(floor),
        monster_weights: @monster_weights.value_for_floor(floor),
        item_weights: @item_weights.value_for_floor(floor)
      )
    end
  end
end
