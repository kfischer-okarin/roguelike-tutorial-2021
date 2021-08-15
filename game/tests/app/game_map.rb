require 'tests/test_helper.rb'

def test_game_remove_entity(_args, assert)
  entity = build_entity
  game_map = build_game_map
  game_map.add_entity entity

  game_map.remove_entity entity

  assert.equal! game_map.entities, []
end

def test_game_map_items(_args, assert)
  item1 = build_item
  item2 = build_item
  game_map = build_game_map
  game_map.add_entity item1
  game_map.add_entity item2
  game_map.add_entity build_actor

  assert.contains_exactly! game_map.items, [item1, item2]
end

def test_game_map_positions_in_effect_radius(_args, assert)
  # 7 oo
  # 6 oo
  # 5 ooX
  # 4 o_X
  # 3 ooX
  # 2 oo
  # 1 oo
  #   0123
  tiles = {
    [2, 3] => :wall,
    [2, 4] => :wall,
    [2, 5] => :wall
  }
  game_map = build_game_map(10, 10, tiles: tiles)

  walkable_positions = game_map.positions_in_radius(center: [1, 4], radius: 3) { |position|
    game_map.walkable?(position.x, position.y)
  }

  assert.contains_exactly! walkable_positions, [
    [0, 7], [1, 7],
    [0, 6], [1, 6],
    [0, 5], [1, 5],
    [0, 4],
    [0, 3], [1, 3],
    [0, 2], [1, 2],
    [0, 1], [1, 1]
  ]
end
