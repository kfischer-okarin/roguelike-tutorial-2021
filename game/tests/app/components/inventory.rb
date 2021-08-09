require 'tests/test_helper.rb'

def test_inventory_add_entity(args, assert)
  TestHelper.init_globals(args)
  entity_data = { items: [] }
  inventory = Components::Inventory.new(TestHelper.build_actor, entity_data)
  item_entity = TestHelper.build_item

  inventory.add_entity(item_entity)

  assert.includes! entity_data[:items], item_entity.id
end

def test_inventory_items(args, assert)
  TestHelper.init_globals(args)
  item_entity = TestHelper.build_item
  inventory = Components::Inventory.new(TestHelper.build_actor, items: [])
  inventory.add_entity item_entity

  assert.equal! inventory.items, [item_entity]
end

def test_inventory_drop(args, assert)
  TestHelper.init_globals(args)
  actor = TestHelper.build_actor
  game_map = TestHelper.build_map_with_entities(
    [3, 4] => actor
  )
  inventory = Components::Inventory.new(actor, items: [])
  item_entity = TestHelper.build_item('Ball')
  item_entity.place inventory

  inventory.drop item_entity

  assert.equal! inventory.items, []
  assert.includes! game_map.items, item_entity
  assert.has_attributes! item_entity, x: 3, y: 4
  assert.includes! TestHelper.log_messages, 'You dropped the Ball'
end
