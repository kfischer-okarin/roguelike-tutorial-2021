require 'tests/test_helper.rb'

def test_game_remove_entity(args, assert)
  TestHelper.init_globals(args)

  entity = TestHelper.build_entity
  game_map = TestHelper.build_map
  game_map.add_entity entity

  game_map.remove_entity entity

  assert.equal! game_map.entities, []
end

def test_game_map_items(args, assert)
  TestHelper.init_globals(args)

  item1 = TestHelper.build_item
  item2 = TestHelper.build_item
  game_map = TestHelper.build_map
  game_map.add_entity item1
  game_map.add_entity item2
  game_map.add_entity TestHelper.build_actor

  assert.contains_exactly! game_map.items, [item1, item2]
end

