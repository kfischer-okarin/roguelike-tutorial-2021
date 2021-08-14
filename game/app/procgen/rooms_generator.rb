module Procgen
  class RoomsGenerator < Generator
    def initialize(map_width:, map_height:, max_rooms:, min_size:, max_size:)
      super()
      @map_width = map_width
      @map_height = map_height
      @max_rooms = max_rooms
      @min_size = min_size
      @max_size = max_size
    end

    def generate
      [].tap { |result|
        @max_rooms.times do
          new_room = build_random_room
          next if result.any? { |room| room.intersects? new_room }

          result << new_room
        end
      }
    end

    def build_random_room
      w = random_room_size
      h = random_room_size
      x = rng.random_int_between(0, @map_width - w)
      y = rng.random_int_between(0, @map_height - h)
      RectangularRoom.new(x, y, w, h)
    end

    def random_room_size
      rng.random_int_between(@min_size, @max_size)
    end
  end
end
