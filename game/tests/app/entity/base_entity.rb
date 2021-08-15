require 'tests/test_helper.rb'

def test_base_entity_place_in_game_map(_args, assert)
  entity = build_entity
  game_map = build_game_map(width: 10, height: 10)

  entity.place(game_map, x: 4, y: 4)

  assert.has_attributes! entity, x: 4, y: 4, parent: game_map
  assert.has_attributes! entity.data, parent: { type: :game_map }
  assert.includes! game_map.entities, entity
end

def test_base_item_place_in_inventory(_args, assert)
  item = build_item
  actor = build_actor
  build_game_map_with_entities(item, actor)

  item.place(actor.inventory)

  assert.has_attributes! item, x: nil, y: nil, parent: actor.inventory
  assert.has_attributes! item.data, parent: { type: :inventory, entity_id: actor.id }
  assert.includes! actor.inventory.items, item
end

def test_base_entity_parent_inventory_from_data(_args, assert)
  actor = build_actor
  entity = build_item
  entity.data.parent = { type: :inventory, entity_id: actor.id }

  assert.equal! entity.parent, actor.inventory
end
