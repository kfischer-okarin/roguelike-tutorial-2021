require 'tests/test_helper.rb'

def test_base_entity_place_in_game_map(_args, assert)
  entity = build_entity
  game_map = build_game_map(10, 10)

  entity.place(game_map, x: 4, y: 4)

  assert.has_attributes! entity, x: 4, y: 4, parent: game_map
  assert.has_attributes! entity.data, parent: { type: :game_map }
  assert.includes! game_map.entities, entity
end

def test_base_entity_place_in_inventory(_args, assert)
  entity = build_entity
  actor = build_actor
  build_game_map_with_entities(
    [4, 4] => entity,
    [5, 5] => actor
  )

  entity.place(actor.inventory)

  assert.has_attributes! entity, x: nil, y: nil, parent: actor.inventory
  assert.has_attributes! entity.data, parent: { type: :inventory, entity_id: actor.id }
  assert.includes! actor.inventory.items, entity
end

def test_base_entity_parent_inventory_from_data(_args, assert)
  actor = build_actor
  entity = build_item
  entity.data.parent = { type: :inventory, entity_id: actor.id }

  assert.equal! entity.parent, actor.inventory
end
