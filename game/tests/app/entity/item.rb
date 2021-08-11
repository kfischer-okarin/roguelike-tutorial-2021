require 'tests/test_helper.rb'

def test_item_has_consumable_according_to_type(_args, assert)
  healing_entity = build_item(type: :healing, amount: 5)
  lightning_damage_entity = build_item(type: :lightning_damage, amount: 5, maximum_range: 10)
  confusion_entity = build_item(type: :confusion, turns: 10)

  assert.equal! healing_entity.consumable.class, Components::Healing
  assert.equal! lightning_damage_entity.consumable.class, Components::LightningDamage
  assert.equal! confusion_entity.consumable.class, Components::Confusion
end
