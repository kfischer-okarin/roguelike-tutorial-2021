require 'tests/test_helper.rb'

def test_confusion_changes_ai_to_confused(_args, assert)
  item = build_item type: :confusion, turns: 10
  npc = build_actor hp: 20, items: [item]
  orc = build_actor name: 'Orc'
  build_game_map_with_entities(
    [3, 3] => npc,
    [5, 7] => orc
  )

  item.consumable.activate(npc, orc)

  assert.has_attributes! orc.ai, class: Components::AI::Confused,
                                 turns: 10,
                                 previous_ai: { type: :enemy, data: {} }
  assert.includes! log_messages, 'The eyes of the Orc look vacant, as it starts to stumble around!'
  assert.includes_no! npc.inventory.items, item
end
