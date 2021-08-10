require 'tests/test_helper.rb'

def test_room_entities(args, assert)
  TestHelper.init_globals(args)
  room = Procgen::RectangularRoom.new(5, 5, 5, 6)
  rng = TestHelper.stub(
    random_int_between: TestHelper.allow_calls(
      :random_int_between,
      [
        [[0, 2], 1], # number of monsters
        [[0, 3], 2]  # number of items
      ]
    ),
    random_position_in_rect: TestHelper.allow_calls(
      :random_position_in_rect,
      [
        [[[6, 6, 3, 4]], [6, 6]], # Monster position
        [[[6, 6, 3, 4]], [7, 7]], # Item 1 position
        [[[6, 6, 3, 4]], [8, 7]]  # Item 2 position
      ]
    ),
    rand: TestHelper.allow_calls(
      :rand,
      [
        [[], 0.9], # monster type -> bearman
        [[], 0.5], # item 1 type -> bandages
        [[], 0.9]  # item 2 type -> megavolt_capsule
      ]
    )
  )
  generator = Procgen::RoomEntitiesGenerator.new(
    rng,
    max_monsters_per_room: 2,
    max_items_per_room: 3
  )

  result = generator.generate_for(room)

  assert.equal! result, [
    { type: :cyborg_bearman, x: 6, y: 6 },
    { type: :bandages, x: 7, y: 7 },
    { type: :megavolt_capsule, x: 8, y: 7 }
  ]
end
