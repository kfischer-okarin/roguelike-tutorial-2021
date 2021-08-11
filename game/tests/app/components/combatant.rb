require 'tests/test_helper.rb'

def test_combatant_heal(_args, assert)
  npc = build_actor hp: 5, max_hp: 10

  healed_amount = npc.combatant.heal(2)

  assert.equal! npc.combatant.hp, 7
  assert.equal! healed_amount, 2

  healed_amount = npc.combatant.heal(20)

  assert.equal! npc.combatant.hp, 10
  assert.equal! healed_amount, 3
end

def test_combatant_take_damage(_args, assert)
  npc = build_actor hp: 5, max_hp: 10
  die_calls = mock_method(npc, :die)

  npc.combatant.take_damage(2)

  assert.equal! npc.combatant.hp, 3
  assert.true! die_calls.empty?

  npc.combatant.take_damage(20)

  assert.equal! npc.combatant.hp, 0
  assert.equal! die_calls.length, 1
end
