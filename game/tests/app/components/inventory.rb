require 'tests/test_helper.rb'

def test_inventory_items(_args, assert)
  actor = build_actor
  item = build_item
  actor.inventory.add_entity item

  assert.equal! actor.inventory.items, [item]
end

def test_inventory_drop(_args, assert)
  ball = build_item name: 'Ball'
  actor = build_actor items: [ball]
  game_map = build_game_map_with_entities(
    [3, 4] => actor
  )

  actor.inventory.drop ball

  assert.equal! actor.inventory.items, []
  assert.includes! game_map.items, ball
  assert.has_attributes! ball, x: 3, y: 4
  assert.includes! log_messages, 'You dropped the Ball'
end

def test_inventory_drop_unequips_item(_args, assert)
  weapon = build_item equippable: { slot: :weapon }
  actor = build_actor(items: [weapon])
  actor.equipment.equip weapon
  game_map = build_game_map_with_entities(
    [3, 4] => actor
  )

  actor.inventory.drop weapon

  assert.equal! actor.inventory.items, []
  assert.includes! game_map.items, weapon
  assert.has_attributes! weapon, x: 3, y: 4
  assert.equal! actor.equipment.weapon, nil
  assert.equal! weapon.equippable.equipped_by, nil
end
