require 'tests/test_helper.rb'

def test_dungeon_builder_place_room(_args, assert)
  builder = Procgen::DungeonBuilder.new(
    player: Entities.player,
    width: 30,
    height: 30,
    rooms: [
      Procgen::RectangularRoom.new(2, 2, 6, 6),
      Procgen::RectangularRoom.new(7, 12, 5, 7),
      Procgen::RectangularRoom.new(10, 20, 6, 6)
    ],
    corridors: [
      Procgen::Corridor.new(from: [5, 5], to: [5, 15]),
      Procgen::Corridor.new(from: [5, 15], to: [9, 15]),
      Procgen::Corridor.new(from: [9, 15], to: [13, 15]),
      Procgen::Corridor.new(from: [13, 15], to: [13, 23])
    ],
    entities: [
      { type: :cyborg_bearman, x: 4, y: 4 },
      { type: :grenade, x: 10, y: 15 }
    ]
  )

  result = builder.build

  assert.has_attributes! result, width: 30, height: 30
  assert.false! result.walkable?(2, 3), 'expected wall'
  assert.true! result.walkable?(3, 3), 'expected room'
  assert.true! result.walkable?(5, 15), 'expected corridor'

  entity_positions = result.entities.map { |entity|
    { name: entity.name, x: entity.x, y: entity.y }
  }
  assert.contains_exactly! entity_positions, [
    { name: 'Cyborg Bearman', x: 4, y: 4 },
    { name: 'Grenade', x: 10, y: 15 },
    { name: 'Player', x: 5, y: 5 }
  ]
  assert.equal! result.portal_location, [13, 23]
  assert.equal! result.data.tiles[23 * 30 + 13], :portal
end
