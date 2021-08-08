require 'tests/test_helper.rb'

def test_healing_consumable_heals_consumer_hp(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.stub(
    entity: TestHelper.stub(name: 'Potion')
  )
  healing_consumable = Components::HealingConsumable.new(entity, amount: 3)

  npc = TestHelper.build_combatant('NPC', hp: 20)
  npc.combatant.take_damage(10)

  healing_consumable.activate(npc)

  assert.includes! TestHelper.log_messages, 'You consume the Potion and recover 3 HP!'
  assert.equal! npc.combatant.hp, 13
end

def test_healing_consumable_heals_until_max_hp(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.stub(
    entity: TestHelper.stub(name: 'Potion')
  )
  healing_consumable = Components::HealingConsumable.new(entity, amount: 20)

  npc = TestHelper.build_combatant('NPC', hp: 20)
  npc.combatant.take_damage(5)

  healing_consumable.activate(npc)

  assert.includes! TestHelper.log_messages, 'You consume the Potion and recover 5 HP!'
  assert.equal! npc.combatant.hp, 20
end

def test_healing_consumable_consuming_with_max_hp_is_impossible(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.stub(
    entity: TestHelper.stub(name: 'Potion')
  )
  healing_consumable = Components::HealingConsumable.new(entity, amount: 1)

  npc = TestHelper.build_combatant('NPC', hp: 20)

  assert.raises_with_message! Action::Impossible, 'Your health is already full.' do
    healing_consumable.activate(npc)
  end
end
