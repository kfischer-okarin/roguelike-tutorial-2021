require 'tests/test_helper.rb'

def test_room_entities(args, assert)
  TestHelper.init_globals(args)
  room = Procgen::RectangularRoom.new(5, 5, 3, 4)
  rng = TestHelper.stub(
    random_int_between: TestHelper.allow_calls(
      :random_int_between,
      [
        [[0, 2], 1], # number of monsters
        [[6, 6], 6], # monster x
        [[6, 7], 6]  # monster y
      ]
    ),
    rand: TestHelper.allow_calls(
      :rand,
      [
        [[], 0.9] # monster type -> bearman
      ]
    )
  )
  generator = Procgen::RoomEntitiesGenerator.new(
    rng,
    max_monsters_per_room: 2
  )

  result = generator.generate_for(room)

  assert.equal! result, [
    { type: :cyborg_bearman, x: 6, y: 6 }
  ]
end
