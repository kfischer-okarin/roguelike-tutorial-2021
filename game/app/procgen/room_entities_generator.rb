module Procgen
  class RoomEntitiesGenerator
    def initialize(rng, max_monsters_per_room:)
      @rng = rng
      @max_monsters_per_room = max_monsters_per_room
    end

    def generate_for(room)
      entity_area = room.inner_rect
      @rng.random_int_between(0, @max_monsters_per_room).map {
        x, y = @rng.random_position_in_rect(entity_area)
        {
          x: x,
          y: y,
          type: @rng.rand < 0.8 ? :mutant_spider : :cyborg_bearman
        }
      }
    end
  end
end
