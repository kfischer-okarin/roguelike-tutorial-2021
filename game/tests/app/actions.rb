require 'tests/test_helper.rb'

def test_melee_action_deal_damage(args, assert)
  TestHelper.init_globals(args)
  attacker = TestHelper.build_actor('Attacker', hp: 30, defense: 2, power: 5)
  defender = TestHelper.build_actor('Defender', hp: 30, defense: 1, power: 3)
  TestHelper.build_map_with_entities(
    [3, 3] => attacker,
    [3, 4] => defender
  )

  MeleeAction.new(attacker, dx: 0, dy: 1).perform

  assert.includes! TestHelper.log_messages, 'Attacker attacks Defender for 4 hit points.'
  assert.equal! defender.combatant.hp, 26
end

def test_melee_action_deal_no_damage(args, assert)
  TestHelper.init_globals(args)
  attacker = TestHelper.build_actor('Attacker', hp: 30, defense: 2, power: 1)
  defender = TestHelper.build_actor('Defender', hp: 30, defense: 5, power: 3)
  TestHelper.build_map_with_entities(
    [3, 3] => attacker,
    [3, 4] => defender
  )

  MeleeAction.new(attacker, dx: 0, dy: 1).perform

  assert.includes! TestHelper.log_messages, 'Attacker attacks Defender but does no damage.'
  assert.equal! defender.combatant.hp, 30
end

def test_melee_action_nothing_to_attack(args, assert)
  TestHelper.init_globals(args)
  attacker = TestHelper.build_actor('Attacker', hp: 30, defense: 2, power: 1)
  TestHelper.build_map_with_entities(
    [3, 3] => attacker
  )

  assert.raises_with_message!(Action::Impossible, 'Nothing to attack.') do
    MeleeAction.new(attacker, dx: 0, dy: -1).perform
  end
end

def test_move_action_success(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.build_entity
  TestHelper.build_map_with_entities(
    [3, 3] => entity
  )

  MovementAction.new(entity, dx: 0, dy: -1).perform

  assert.equal! entity.x, 3
  assert.equal! entity.y, 2
end

def test_move_action_cannot_move_into_wall(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.build_entity
  game_map = TestHelper.build_map_with_entities(
    [3, 3] => entity
  )
  game_map.set_tile(4, 3, Tiles.wall)

  assert.raises_with_message!(Action::Impossible, 'That way is blocked.') do
    MovementAction.new(entity, dx: 1, dy: 0).perform
  end
  assert.equal! entity.x, 3
  assert.equal! entity.y, 3
end

def test_move_action_cannot_move_beyond_map_bounds(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.build_entity
  game_map = TestHelper.build_map(4, 4)
  entity.place(game_map, x: 3, y: 3)

  assert.raises_with_message!(Action::Impossible, 'That way is blocked.') do
    MovementAction.new(entity, dx: 1, dy: 0).perform
  end
  assert.equal! entity.x, 3
  assert.equal! entity.y, 3
end

def test_pickup_action(args, assert)
  TestHelper.init_globals(args)
  actor = TestHelper.build_actor
  item = TestHelper.build_item('Potion')
  game_map = TestHelper.build_map_with_entities(
    [3, 3] => actor,
    [1, 1] => TestHelper.build_item
  )
  item.place(game_map, x: 3, y: 3)

  PickupAction.new(actor).perform

  assert.includes! actor.inventory.items, item
  assert.includes_no! game_map.items, item
  assert.contains_exactly! TestHelper.log_messages, ['You picked up the Potion!']
end

def test_pickup_action_when_not_at_same_position_is_impossible(args, assert)
  TestHelper.init_globals(args)
  actor = TestHelper.build_actor
  item = TestHelper.build_item('Potion')
  game_map = TestHelper.build_map
  actor.place(game_map, x: 3, y: 4)
  item.place(game_map, x: 3, y: 3)

  assert.raises_with_message!(Action::Impossible, 'There is nothing to pick up.') do
    PickupAction.new(actor).perform
  end

  assert.includes_no! actor.inventory.items, item
  assert.includes! game_map.items, item
end

def test_use_item_action_activates_consumable(args, assert)
  TestHelper.init_globals(args)
  actor = TestHelper.build_actor
  item = TestHelper.build_item
  item_consumer = nil
  item.consumable.define_singleton_method :activate do |consumer|
    item_consumer = consumer
  end

  UseItemAction.new(actor, item).perform

  assert.equal! item_consumer, actor
end

def test_drop_item_action_drops_from_inventory(args, assert)
  TestHelper.init_globals(args)
  actor = TestHelper.build_actor
  item = TestHelper.build_item
  dropped_item = nil
  actor.inventory.define_singleton_method :drop do |selected_item|
    dropped_item = selected_item
  end

  DropItemAction.new(actor, item).perform

  assert.equal! dropped_item, item
end
