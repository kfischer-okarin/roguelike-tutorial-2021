require 'tests/test_helper.rb'

def test_confusion_changes_ai_to_confused(_args, assert)
  item = build_item type: :confusion, turns: 10
  npc = build_actor(items: [item])
  orc = build_actor name: 'Orc'
  build_game_map_with_entities(
    [3, 3] => npc,
    [5, 7] => orc
  )

  item.consumable.activate npc, [5, 7]

  assert.has_attributes! orc.ai, class: Components::AI::Confused,
                                 turns: 10,
                                 previous_ai: { type: :enemy, data: {} }
  assert.includes! log_messages, 'The eyes of the Orc look vacant, as it starts to stumble around!'
  assert.includes_no! npc.inventory.items, item
end

def test_confusion_get_action_starts_position_selection(_args, assert)
  item = build_item type: :confusion, turns: 10
  npc = build_actor(items: [item])

  returned_action = item.consumable.get_action(npc)

  assert.equal! $game.scene.class, Scenes::PositionSelection
  assert.nil! returned_action

  returned_action = $game.scene.action_for_position [5, 4]

  assert.equal! returned_action, UseItemOnPositionAction.new(npc, item, position: [5, 4])
end

def test_confusion_cannot_target_non_visible_position(_args, assert)
  item = build_item type: :confusion, turns: 10
  npc = build_actor(items: [item])
  game_map = build_game_map_with_entities(
    [3, 3] => npc
  )
  make_positions_non_visible(game_map, [[4, 4]])

  assert.raises_with_message! Action::Impossible, 'You cannot target an area that you cannot see.' do
    item.consumable.activate npc, [4, 4]
  end
end

def test_confusion_must_target_actor(_args, assert)
  item = build_item type: :confusion, turns: 10
  npc = build_actor(items: [item])
  build_game_map_with_entities(
    [3, 3] => npc
  )

  assert.raises_with_message! Action::Impossible, 'You must select an enemy to target.' do
    item.consumable.activate npc, [4, 4]
  end
end

def test_confusion_cannot_target_self(_args, assert)
  item = build_item type: :confusion, turns: 10
  npc = build_actor(items: [item])
  build_game_map_with_entities(
    [3, 3] => npc
  )

  assert.raises_with_message! Action::Impossible, 'You cannot confuse yourself!' do
    item.consumable.activate npc, [3, 3]
  end
end
