require 'tests/test_helper.rb'

def test_healing_heals_consumer_hp(_args, assert)
  potion = build_item name: 'Potion', type: :healing, amount: 3
  npc = build_actor hp: 20, items: [potion]
  npc.combatant.take_damage(10)

  potion.consumable.activate(npc)

  assert.includes! log_messages, 'You use the Potion and recover 3 HP!'
  assert.equal! npc.combatant.hp, 13
  assert.includes_no! npc.inventory.items, potion
end

def test_healing_heals_until_max_hp(_args, assert)
  potion = build_item name: 'Potion', type: :healing, amount: 20
  npc = build_actor hp: 20, items: [potion]
  npc.combatant.take_damage(5)

  potion.consumable.activate(npc)

  assert.includes! TestHelper.log_messages, 'You use the Potion and recover 5 HP!'
  assert.equal! npc.combatant.hp, 20
  assert.includes_no! npc.inventory.items, potion
end

def test_healing_consuming_with_max_hp_is_impossible(_args, assert)
  potion = build_item name: 'Potion', type: :healing, amount: 1
  npc = build_actor hp: 20, items: [potion]

  assert.raises_with_message! Action::Impossible, 'Your health is already full.' do
    potion.consumable.activate(npc)
  end
  assert.includes! npc.inventory.items, potion
end

def test_healing_get_action_returns_use_action(_args, assert)
  potion = build_item type: :healing, amount: 1
  consumer = build_actor

  action = potion.consumable.get_action(consumer)

  assert.equal! action, UseItemAction.new(consumer, potion)
end
