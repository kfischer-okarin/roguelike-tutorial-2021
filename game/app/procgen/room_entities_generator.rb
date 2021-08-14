module Procgen
  class RoomEntitiesGenerator
    attr_writer :rng

    def initialize(max_monsters_per_room:, max_items_per_room:)
      @max_monsters_per_room = max_monsters_per_room
      @max_items_per_room = max_items_per_room
    end

    def rng
      @rng ||= RNG.new
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
        x, y = @rng.random_position_in_rect(area)
        result << {
          x: x,
          y: y,
          type: @rng.rand < 0.8 ? :mutant_spider : :cyborg_bearman
        }
      end
    end

    def add_items(result, area)
      rng.random_int_between(0, @max_items_per_room).each do
        x, y = @rng.random_position_in_rect(area)
        type = case @rng.rand
               when 0...0.7
                 :bandages
               when 0.7...0.8
                 :grenade
               when 0.8...0.9
                 :neurosonic_emitter
               else
                 :megavolt_capsule
               end
        result << { x: x, y: y, type: type }
      end
    end
  end
end
