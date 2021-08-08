require 'tests/test_helper.rb'

def test_combatant_heal(_args, assert)
  combatant = Components::Combatant.new(TestHelper::Spy.new, { hp: 5, max_hp: 10 })

  healed_amount = combatant.heal(2)

  assert.equal! combatant.hp, 7
  assert.equal! healed_amount, 2

  healed_amount = combatant.heal(20)

  assert.equal! combatant.hp, 10
  assert.equal! healed_amount, 3
end

def test_combatant_take_damage(_args, assert)
  entity = TestHelper::Spy.new
  parent = TestHelper.stub(entity: entity)
  combatant = Components::Combatant.new(parent, { hp: 5, max_hp: 10 })

  combatant.take_damage(2)

  assert.equal! combatant.hp, 3
  assert.includes_no! entity.calls, [:die, []]

  combatant.take_damage(20)

  assert.equal! combatant.hp, 0
  assert.includes! entity.calls, [:die, []]
end
