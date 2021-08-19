require 'tests/test_helper.rb'

def test_equipment_equip_weapon(_args, assert)
  actor = build_actor
  item = build_item(equippable: { slot: :weapon })

  actor.equipment.equip(item)

  assert.equal! actor.equipment.weapon, item
  assert.equal! item.equippable.equipped_by, actor

  actor.equipment.unequip(item)

  assert.equal! actor.equipment.weapon, nil
  assert.equal! item.equippable.equipped_by, nil
end

def test_equipment_equip_armor(_args, assert)
  actor = build_actor
  item = build_item(name: 'Fire Armor', equippable: { slot: :armor })

  actor.equipment.equip(item)

  assert.equal! actor.equipment.armor, item
  assert.equal! item.equippable.equipped_by, actor
  assert.includes! log_messages, 'You equip the Fire Armor.'

  actor.equipment.unequip(item)

  assert.equal! actor.equipment.armor, nil
  assert.equal! item.equippable.equipped_by, nil
  assert.includes! log_messages, 'You remove the Fire Armor.'
end

def test_equipment_equip_unequips_previous_equipment(_args, assert)
  actor = build_actor
  armor1 = build_item(equippable: { slot: :armor })
  armor2 = build_item(equippable: { slot: :armor })

  actor.equipment.equip(armor1)
  actor.equipment.equip(armor2)

  assert.equal! actor.equipment.armor, armor2
  assert.equal! armor2.equippable.equipped_by, actor
  assert.equal! armor1.equippable.equipped_by, nil
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

def test_equipment_equipped(_args, assert)
  actor = build_actor
  weapon = build_item(equippable: { slot: :weapon, defense_bonus: 3 })
  armor = build_item(equippable: { slot: :armor, defense_bonus: 2 })
  unequipped = build_item(equippable: { slot: :armor, defense_bonus: 2 })
  actor.equipment.equip(weapon)
  actor.equipment.equip(armor)

  assert.true! actor.equipment.equipped?(weapon)
  assert.true! actor.equipment.equipped?(armor)
  assert.false! actor.equipment.equipped?(unequipped)
end
