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

def test_combatant_power(_args, assert)
  actor = build_actor base_power: 2
  weapon = build_item equippable: { slot: :weapon, power_bonus: 2 }
  actor.equipment.equip weapon

  assert.equal! actor.combatant.power, 4
end

def test_combatant_defense(_args, assert)
  actor = build_actor base_defense: 2
  armor = build_item equippable: { slot: :armor, defense_bonus: 3 }
  actor.equipment.equip armor

  assert.equal! actor.combatant.defense, 5
end
