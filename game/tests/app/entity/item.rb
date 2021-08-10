require 'tests/test_helper.rb'

def test_item_has_consumable_according_to_type(args, assert)
  TestHelper.init_globals(args)

  healing_entity = Entity.build(:healing_item, consumable: { type: :healing, amount: 5 })
  lightning_damage_entity = Entity.build(
    :lightning_damage_item,
    consumable: { type: :lightning_damage, amount: 5, maximum_range: 10 }
  )

  assert.equal! healing_entity.consumable.class, Components::Healing
  assert.equal! lightning_damage_entity.consumable.class, Components::LightningDamage
end
