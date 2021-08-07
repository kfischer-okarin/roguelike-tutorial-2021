require 'tests/test_helper.rb'

def test_define_item(_args, assert)
  EntityPrototypes.define_item :potion,
                               name: 'Potion',
                               char: '!', color: [200, 200, 200],
                               consumable: { amount: 4 }

  entity = EntityPrototypes.build(:potion)
  assert.true! entity.is_a? Entity::Item
  assert.has_attributes! entity, char: '!',
                                 color: [200, 200, 200],
                                 blocks_movement?: false,
                                 render_order: RenderOrder::ITEM
  assert.true! entity.consumable.is_a?(Components::HealingConsumable)
  assert.has_attributes! entity.consumable, amount: 4
end
