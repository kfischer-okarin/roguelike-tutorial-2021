require 'tests/test_helper.rb'

def test_explosion_damages_all_actors_in_radius(_args, assert)
  item = build_item type: :explosion, radius: 3, damage: 12
  npc = build_actor(name: 'NPC', items: [item], hp: 20)
  orc = build_actor name: 'Orc', hp: 8
  other_enemy = build_actor hp: 6
  build_game_map_with_entities(
    [3, 3] => npc,
    [5, 7] => orc,
    [20, 20] => other_enemy
  )

  item.consumable.activate npc, [6, 6]

  assert.contains_exactly! log_messages, [
    'The NPC is engulfed in a fiery explosion, taking 12 damage!',
    'The Orc is engulfed in a fiery explosion, taking 12 damage!',
    'Orc is dead!'
  ]
  assert.has_attributes! npc.combatant, hp: 8
  assert.has_attributes! orc.combatant, hp: 0
  assert.has_attributes! other_enemy.combatant, hp: 6
  assert.includes_no! npc.inventory.items, item
end

def test_explosion_impossible_without_targets_in_area(_args, assert)
  item = build_item type: :explosion, radius: 3, damage: 12
  npc = build_actor(name: 'NPC', items: [item], hp: 20)
  enemy = build_actor hp: 8
  build_game_map_with_entities(
    [3, 3] => npc,
    [20, 20] => enemy
  )

  assert.raises_with_message! Action::Impossible, 'There are no targets in the radius.' do
    item.consumable.activate npc, [7, 7]
  end

  assert.has_attributes! npc.combatant, hp: 20
  assert.has_attributes! enemy.combatant, hp: 8
  assert.includes! npc.inventory.items, item
end

def test_explosion_impossible_to_target_non_visible_position(_args, assert)
  item = build_item type: :explosion, radius: 3, damage: 12
  npc = build_actor(name: 'NPC', items: [item], hp: 20)
  game_map = build_game_map_with_entities(
    [3, 3] => npc
  )
  make_positions_non_visible game_map, [[4, 5]]

  assert.raises_with_message! Action::Impossible, 'You cannot target an area that you cannot see.' do
    item.consumable.activate npc, [4, 5]
  end

  assert.has_attributes! npc.combatant, hp: 20
  assert.includes! npc.inventory.items, item
end

def test_explosion_get_action_starts_explosion_area_selection(_args, assert)
  item = build_item type: :explosion, radius: 3, damage: 12
  npc = build_actor(items: [item])

  item.consumable.get_action(npc)

  assert.equal! $game.scene.class, Scenes::ExplosionAreaSelection

  returned_action = $game.scene.action_for_position [5, 4]

  assert.equal! returned_action, UseItemOnPositionAction.new(npc, item, position: [5, 4])
end
