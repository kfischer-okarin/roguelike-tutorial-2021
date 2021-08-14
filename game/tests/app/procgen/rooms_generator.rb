require 'tests/test_helper.rb'

def test_rooms_generator(_args, assert)
  rng = TestHelper::Mock.new
  # room 1 width
  rng.expect_call :random_int_between, args: [6, 10], return_value: 7
  # room 1 height
  rng.expect_call :random_int_between, args: [6, 10], return_value: 8
  # room 1 x
  rng.expect_call :random_int_between, args: [0, 73], return_value: 33
  # room 1 y
  rng.expect_call :random_int_between, args: [0, 37], return_value: 20
  # room 2 overlaps room 1
  # room 2 width
  rng.expect_call :random_int_between, args: [6, 10], return_value: 6
  # room 2 height
  rng.expect_call :random_int_between, args: [6, 10], return_value: 10
  # room 2 x
  rng.expect_call :random_int_between, args: [0, 74], return_value: 30
  # room 2 y
  rng.expect_call :random_int_between, args: [0, 35], return_value: 15
  # room 3 width
  rng.expect_call :random_int_between, args: [6, 10], return_value: 7
  # room 3 height
  rng.expect_call :random_int_between, args: [6, 10], return_value: 7
  # room 3 x
  rng.expect_call :random_int_between, args: [0, 73], return_value: 2
  # room 3 y
  rng.expect_call :random_int_between, args: [0, 38], return_value: 30

  generator = Procgen::RoomsGenerator.new(
    map_width: 80,
    map_height: 45,
    max_rooms: 3,
    min_size: 6,
    max_size: 10
  )
  generator.rng = rng

  rooms = generator.generate

  rng.assert_all_calls_received!(assert)
  assert.equal! rooms, [
    Procgen::RectangularRoom.new(33, 20, 7, 8),
    Procgen::RectangularRoom.new(2, 30, 7, 7)
  ]
end
