require 'tests/test_helper.rb'

def test_equippable_activate_toggles_equip_state(_args, assert)
  actor = build_actor
  weapon = build_item(equippable: { slot: :weapon })

  weapon.activate(actor)

  assert.true! actor.equipment.equipped?(weapon)

  weapon.activate(actor)

  assert.false! actor.equipment.equipped?(weapon)
end

def test_equippable_get_action_returns_use_item_action(_args, assert)
  actor = build_actor
  weapon = build_item(equippable: { slot: :weapon })

  action = weapon.get_action(actor)

  assert.equal! action, UseItemAction.new(actor, weapon)
end
