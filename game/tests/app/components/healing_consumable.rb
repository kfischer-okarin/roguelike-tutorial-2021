require 'tests/test_helper.rb'

def test_healing_consumable_heals_consumer_hp(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_item('Potion')
  healing_consumable = Components::HealingConsumable.new(item, amount: 3)
  npc = TestHelper.build_actor('NPC', hp: 20)
  item.place npc.inventory
  npc.combatant.take_damage(10)

  healing_consumable.activate(npc)

  assert.includes! TestHelper.log_messages, 'You use the Potion and recover 3 HP!'
  assert.equal! npc.combatant.hp, 13
  assert.includes_no! npc.inventory.items, item
end

def test_healing_consumable_heals_until_max_hp(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_entity('Potion')
  healing_consumable = Components::HealingConsumable.new(item, amount: 20)
  npc = TestHelper.build_actor('NPC', hp: 20)
  item.place npc.inventory
  npc.combatant.take_damage(5)

  healing_consumable.activate(npc)

  assert.includes! TestHelper.log_messages, 'You use the Potion and recover 5 HP!'
  assert.equal! npc.combatant.hp, 20
  assert.includes_no! npc.inventory.items, item
end

def test_healing_consumable_consuming_with_max_hp_is_impossible(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_entity('Potion')
  healing_consumable = Components::HealingConsumable.new(item, amount: 1)
  npc = TestHelper.build_actor('NPC', hp: 20)
  item.place npc.inventory

  assert.raises_with_message! Action::Impossible, 'Your health is already full.' do
    healing_consumable.activate(npc)
  end
  assert.includes! npc.inventory.items, item
end
