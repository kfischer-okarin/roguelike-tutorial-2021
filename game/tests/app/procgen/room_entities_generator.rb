require 'tests/test_helper.rb'

def test_room_entities(_args, assert)
  room = Procgen::RectangularRoom.new(5, 5, 5, 6)
  rng = TestHelper::Mock.new
  # number of monsters
  rng.expect_call :random_int_between, args: [0, 2], return_value: 1
  # monster position
  rng.expect_call :random_position_in_rect, args: [[6, 6, 3, 4]], return_value: [6, 6]
  # monster type -> bearman
  rng.expect_call :rand, return_value: 0.9
  # number of items
  rng.expect_call :random_int_between, args: [0, 5], return_value: 4
  # item 1 position
  rng.expect_call :random_position_in_rect, args: [[6, 6, 3, 4]], return_value: [7, 7]
  # item 1 type -> bandages
  rng.expect_call :rand, return_value: 0.5
  # item 2 position
  rng.expect_call :random_position_in_rect, args: [[6, 6, 3, 4]], return_value: [8, 7]
  # item 2 type -> megavolt_capsule
  rng.expect_call :rand, return_value: 0.9
  # item 3 position
  rng.expect_call :random_position_in_rect, args: [[6, 6, 3, 4]], return_value: [6, 7]
  # item 3 type -> neurosonic_emitter
  rng.expect_call :rand, return_value: 0.8
  # item 4 position
  rng.expect_call :random_position_in_rect, args: [[6, 6, 3, 4]], return_value: [6, 8]
  # item 4 type -> grenade
  rng.expect_call :rand, return_value: 0.7
  generator = Procgen::RoomEntitiesGenerator.new(
    max_monsters_per_room: 2,
    max_items_per_room: 5
  )
  generator.rng = rng

  result = generator.generate_for(room)

  rng.assert_all_calls_received!(assert)
  assert.equal! result, [
    { type: :cyborg_bearman, x: 6, y: 6 },
    { type: :bandages, x: 7, y: 7 },
    { type: :megavolt_capsule, x: 8, y: 7 },
    { type: :neurosonic_emitter, x: 6, y: 7 },
    { type: :grenade, x: 6, y: 8 }
  ]
end
