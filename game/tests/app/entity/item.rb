require 'tests/test_helper.rb'

def test_item_has_consumable_according_to_type(_args, assert)
  healing_entity = build_item consumable: { type: :healing, amount: 5 }
  lightning_damage_entity = build_item consumable: { type: :lightning_damage, amount: 5, maximum_range: 10 }
  confusion_entity = build_item consumable: { type: :confusion, turns: 10 }
  explosion_entity = build_item consumable: { type: :explosion, damage: 12, radius: 2 }

  assert.equal! healing_entity.consumable.class, Components::Healing
  assert.equal! lightning_damage_entity.consumable.class, Components::LightningDamage
  assert.equal! confusion_entity.consumable.class, Components::Confusion
  assert.equal! explosion_entity.consumable.class, Components::Explosion
end
