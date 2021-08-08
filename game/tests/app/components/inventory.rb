require 'tests/test_helper.rb'

def test_inventory_add_entity(args, assert)
  TestHelper.init_globals(args)
  entity_data = { items: [] }
  inventory = Components::Inventory.new(TestHelper.build_entity, entity_data)
  item_entity = TestHelper.build_entity

  inventory.add_entity(item_entity)

  assert.includes! entity_data[:items], item_entity.id
end

def test_inventory_items(args, assert)
  TestHelper.init_globals(args)
  item_entity = TestHelper.build_entity
  Entities << item_entity
  inventory = Components::Inventory.new(TestHelper.build_entity, items: [])
  inventory.add_entity item_entity

  assert.equal! inventory.items, [item_entity]
end
