module Procgen
  class RoomEntitiesGenerator < Generator
    def initialize(max_monsters_per_room:, max_items_per_room:)
      super()
      @max_monsters_per_room = max_monsters_per_room
      @max_items_per_room = max_items_per_room
      @monster_weights = { mutant_spider: 8, cyborg_bearman: 2 }
      @item_weights = {
        bandages: 7,
        grenade: 1,
        neurosonic_emitter: 1,
        megavolt_capsule: 1
      }
    end

    def generate_for(room)
      entity_area = room.inner_rect
      [].tap { |result|
        add_monsters(result, entity_area)
        add_items(result, entity_area)
      }
    end

    def add_monsters(result, area)
      rng.random_int_between(0, @max_monsters_per_room).each do
        x, y = @rng.random_position_in_rect area
        type = @rng.random_from_weighted_elements @monster_weights
        result << { x: x, y: y, type: type }
      end
    end

    def add_items(result, area)
      rng.random_int_between(0, @max_items_per_room).each do
        x, y = @rng.random_position_in_rect area
        type = @rng.random_from_weighted_elements @item_weights
        result << { x: x, y: y, type: type }
      end
    end
  end
end
