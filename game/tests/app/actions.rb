require 'tests/test_helper.rb'

def test_melee_action_deal_damage(_args, assert)
  attacker = build_actor name: 'Attacker', hp: 30, defense: 2, power: 5
  defender = build_actor name: 'Defender', hp: 30, defense: 1, power: 3
  build_game_map_with_entities(
    [3, 3] => attacker,
    [3, 4] => defender
  )

  MeleeAction.new(attacker, dx: 0, dy: 1).perform

  assert.includes! log_messages, 'Attacker attacks Defender for 4 hit points.'
  assert.equal! defender.combatant.hp, 26
end

def test_melee_action_deal_no_damage(_args, assert)
  attacker = build_actor name: 'Attacker', hp: 30, defense: 2, power: 1
  defender = build_actor name: 'Defender', hp: 30, defense: 5, power: 3
  build_game_map_with_entities(
    [3, 3] => attacker,
    [3, 4] => defender
  )

  MeleeAction.new(attacker, dx: 0, dy: 1).perform

  assert.includes! log_messages, 'Attacker attacks Defender but does no damage.'
  assert.equal! defender.combatant.hp, 30
end

def test_melee_action_nothing_to_attack(_args, assert)
  attacker = build_actor name: 'Attacker', hp: 30, defense: 2, power: 1
  build_game_map_with_entities(
    [3, 3] => attacker
  )

  assert.raises_with_message!(Action::Impossible, 'Nothing to attack.') do
    MeleeAction.new(attacker, dx: 0, dy: -1).perform
  end
end

def test_move_action_success(_args, assert)
  entity = build_entity
  build_game_map_with_entities(
    [3, 3] => entity
  )

  MovementAction.new(entity, dx: 0, dy: -1).perform

  assert.equal! entity.x, 3
  assert.equal! entity.y, 2
end

def test_move_action_cannot_move_into_wall(_args, assert)
  entity = build_entity
  game_map = build_game_map(width: 5, height: 5, tiles: { [4, 3] => :wall })
  entity.place(game_map, x: 3, y: 3)

  assert.raises_with_message!(Action::Impossible, 'That way is blocked.') do
    MovementAction.new(entity, dx: 1, dy: 0).perform
  end

  assert.equal! entity.x, 3
  assert.equal! entity.y, 3
end

def test_move_action_cannot_move_beyond_map_bounds(_args, assert)
  entity = build_entity
  game_map = build_game_map(width: 4, height: 4)
  entity.place(game_map, x: 3, y: 3)

  assert.raises_with_message!(Action::Impossible, 'That way is blocked.') do
    MovementAction.new(entity, dx: 1, dy: 0).perform
  end
  assert.equal! entity.x, 3
  assert.equal! entity.y, 3
end

def test_pickup_action(_args, assert)
  actor = build_actor
  item = build_item name: 'Potion'
  game_map = build_game_map_with_entities(
    [3, 3] => [actor, item],
    [1, 1] => build_item
  )

  PickupAction.new(actor).perform

  assert.includes! actor.inventory.items, item
  assert.includes_no! game_map.items, item
  assert.contains_exactly! log_messages, ['You picked up the Potion!']
end

def test_pickup_action_when_not_at_same_position_is_impossible(_args, assert)
  actor = build_actor
  item = build_item
  game_map = build_game_map_with_entities(
    [3, 4] => actor,
    [3, 3] => item
  )

  assert.raises_with_message!(Action::Impossible, 'There is nothing to pick up.') do
    PickupAction.new(actor).perform
  end

  assert.includes_no! actor.inventory.items, item
  assert.includes! game_map.items, item
end

def test_use_item_action_activates_consumable(_args, assert)
  actor = build_actor
  item = build_item
  stub_attribute_with_mock(item, :consumable)

  UseItemAction.new(actor, item).perform

  assert.includes! item.consumable.calls, [:activate, [actor]]
end

def test_use_item_on_position_action_activates_consumable(_args, assert)
  actor = build_actor
  item = build_item
  stub_attribute_with_mock(item, :consumable)

  UseItemOnPositionAction.new(actor, item, position: [3, 3]).perform

  assert.includes! item.consumable.calls, [:activate, [actor, [3, 3]]]
end

def test_drop_item_action_drops_from_inventory(_args, assert)
  actor = build_actor
  item = build_item
  stub_attribute_with_mock(actor, :inventory)

  DropItemAction.new(actor, item).perform

  assert.includes! actor.inventory.calls, [:drop, [item]]
end

def test_drop_item_action_drops_from_inventory(_args, assert)
  actor = build_actor
  item = build_item
  stub_attribute_with_mock(actor, :inventory)

  DropItemAction.new(actor, item).perform

  assert.includes! actor.inventory.calls, [:drop, [item]]
end
