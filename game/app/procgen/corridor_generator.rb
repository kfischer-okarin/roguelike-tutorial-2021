module Procgen
  class CorridorGenerator < Generator
    def generate_for(rooms)
      [].tap { |result|
        (1..(rooms.size - 1)).each do |index|
          first_room_center = rooms[index - 1].center
          second_room_center = rooms[index].center

          corner = random_corner_between first_room_center, second_room_center

          result << Corridor.new(from: first_room_center, to: corner)
          result << Corridor.new(from: corner, to: second_room_center)
        end
      }
    end

    def random_corner_between(point1, point2)
      return [point1.x, point2.y] if rng.rand < 0.5

      [point2.x, point1.y]
    end
  end
end
