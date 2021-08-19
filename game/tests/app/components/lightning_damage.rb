require 'tests/test_helper.rb'

def test_lightning_damage_hits_closest_actor(_args, assert)
  item = build_item type: :lightning_damage, amount: 5, maximum_range: 5
  npc = build_actor items: [item]
  closer_monster = build_actor name: 'Close Monster', hp: 30
  far_monster = build_actor name: 'Far Monster', hp: 30
  build_game_map_with_entities(
    [5, 5] => npc,
    [6, 7] => closer_monster,
    [1, 1] => far_monster
  )

  item.consumable.activate(npc)

  assert.includes! TestHelper.log_messages, 'A lightning bolt strikes the Close Monster with a loud thunder, for 5 damage!'
  assert.equal! closer_monster.combatant.hp, 25
  assert.equal! far_monster.combatant.hp, 30
  assert.includes_no! npc.inventory.items, item
end

def test_lightning_damage_cannot_hit_outside_maximum_range(_args, assert)
  item = build_item type: :lightning_damage, amount: 5, maximum_range: 2
  npc = build_actor items: [item]
  far_monster = build_actor hp: 30
  build_game_map_with_entities(
    [5, 5] => npc,
    [1, 1] => far_monster
  )

  assert.raises_with_message! Action::Impossible, 'No enemy is close enough to strike.' do
    item.consumable.activate(npc)
  end
  assert.equal! far_monster.combatant.hp, 30
  assert.includes! npc.inventory.items, item
end

def test_lightning_damage_cannot_hit_without_target(_args, assert)
  item = build_item type: :lightning_damage, amount: 5, maximum_range: 2
  npc = build_actor items: [item]
  build_game_map_with_entities(
    [5, 5] => npc
  )

  assert.raises_with_message! Action::Impossible, 'No enemy is close enough to strike.' do
    item.consumable.activate(npc)
  end
  assert.includes! npc.inventory.items, item
end

def test_lightning_damage_cannot_hit_non_visible_targets(_args, assert)
  item = build_item type: :lightning_damage, amount: 5, maximum_range: 2
  npc = build_actor items: [item]
  closer_monster = build_actor hp: 30
  game_map = build_game_map_with_entities(
    [5, 5] => npc,
    [5, 6] => closer_monster
  )
  make_positions_non_visible(game_map, [[5, 6]])

  assert.raises_with_message! Action::Impossible, 'No enemy is close enough to strike.' do
    item.consumable.activate(npc)
  end
  assert.equal! closer_monster.combatant.hp, 30
  assert.includes! npc.inventory.items, item
end

def test_lightning_damage_shows_correct_name_when_killing_enemy(_args, assert)
  item = build_item type: :lightning_damage, amount: 30, maximum_range: 2
  npc = build_actor items: [item]
  monster = build_actor name: 'Monster', hp: 10
  build_game_map_with_entities(
    [5, 5] => npc,
    [5, 6] => monster
  )

  item.consumable.activate(npc)

  assert.includes_all! log_messages, [
    'A lightning bolt strikes the Monster with a loud thunder, for 30 damage!',
    'Monster is dead!'
  ]
  assert.equal! monster.combatant.hp, 0
  assert.includes_no! npc.inventory.items, item
end

def test_healing_get_action_returns_use_action(_args, assert)
  item = build_item type: :lightning_damage, amount: 30, maximum_range: 2
  consumer = build_actor

  action = item.get_action(consumer)

  assert.equal! action, UseItemAction.new(consumer, item)
end
