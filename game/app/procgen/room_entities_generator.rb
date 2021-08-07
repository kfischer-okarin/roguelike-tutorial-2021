module Procgen
  class RoomEntitiesGenerator
    def initialize(rng, max_monsters_per_room:)
      @rng = rng
      @max_monsters_per_room = max_monsters_per_room
    end

    def generate_for(room)
      min_x = room.x + 1
      max_x = room.x + room.w - 2
      min_y = room.y + 1
      max_y = room.y + room.h - 2
      @rng.random_int_between(0, @max_monsters_per_room).map {
        {
          x: @rng.random_int_between(min_x, max_x),
          y: @rng.random_int_between(min_y, max_y),
          type: @rng.rand < 0.8 ? :mutant_spider : :cyborg_bearman
        }
      }
    end
  end
end
