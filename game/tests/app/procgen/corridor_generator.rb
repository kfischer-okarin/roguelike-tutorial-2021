require 'tests/test_helper.rb'

def test_corridor_generator(_args, assert)
  rooms = [
    Procgen::RectangularRoom.new(15, 6, 4, 6),
    Procgen::RectangularRoom.new(60, 13, 8, 7),
    Procgen::RectangularRoom.new(10, 23, 10, 10)
  ]
  rng = TestHelper::Mock.new
  # room 1 - 2 same x
  rng.expect_call :rand, return_value: 0.3
  # room 2 - 3 same y
  rng.expect_call :rand, return_value: 0.9

  generator = Procgen::CorridorGenerator.new
  generator.rng = rng

  corridors = generator.generate_for(rooms)

  rng.assert_all_calls_received!(assert)
  assert.equal! corridors, [
    Procgen::Corridor.new(from: [17, 9], to: [17, 16]),
    Procgen::Corridor.new(from: [17, 16], to: [64, 16]),
    Procgen::Corridor.new(from: [64, 16], to: [15, 16]),
    Procgen::Corridor.new(from: [15, 16], to: [15, 28])
  ]
end
