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
