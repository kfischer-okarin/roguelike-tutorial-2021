require 'tests/test_helper.rb'

def test_equipment_equip_weapon(_args, assert)
  actor = build_actor
  item = build_item(equippable: { slot: :weapon })

  actor.equipment.equip(item)

  assert.equal! actor.equipment.weapon, item
end

def test_equipment_equip_armor(_args, assert)
  actor = build_actor
  item = build_item(equippable: { slot: :armor })

  actor.equipment.equip(item)

  assert.equal! actor.equipment.armor, item
end

def test_equipment_power_bonus(_args, assert)
  actor = build_actor

  assert.equal! actor.equipment.power_bonus, 0

  weapon = build_item(equippable: { slot: :weapon, power_bonus: 1 })
  armor = build_item(equippable: { slot: :armor, power_bonus: 2 })
  actor.equipment.equip(weapon)
  actor.equipment.equip(armor)

  assert.equal! actor.equipment.power_bonus, 3
end

def test_equipment_defense_bonus(_args, assert)
  actor = build_actor

  assert.equal! actor.equipment.defense_bonus, 0

  weapon = build_item(equippable: { slot: :weapon, defense_bonus: 3 })
  armor = build_item(equippable: { slot: :armor, defense_bonus: 2 })
  actor.equipment.equip(weapon)
  actor.equipment.equip(armor)

  assert.equal! actor.equipment.defense_bonus, 5
end
