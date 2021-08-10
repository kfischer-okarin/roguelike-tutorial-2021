require 'tests/test_helper.rb'

def test_define_actor(args, assert)
  TestHelper.init_globals(args)
  EntityPrototypes.define_actor :monster,
                                name: 'Monster',
                                char: 'm', color: [100, 0, 0],
                                combatant: { hp: 10, defense: 2, power: 3 }
  entity = EntityPrototypes.build(:monster)

  assert.has_attributes! entity, char: 'm',
                                 color: [100, 0, 0],
                                 blocks_movement?: true,
                                 render_order: RenderOrder::ACTOR

  assert.has_attributes! entity.combatant, hp: 10, max_hp: 10, defense: 2, power: 3
  assert.has_attributes! entity.inventory, items: []
end

def test_define_item(args, assert)
  TestHelper.init_globals(args)
  EntityPrototypes.define_item :potion,
                               name: 'Potion',
                               char: '!', color: [200, 200, 200],
                               consumable: { type: :healing, amount: 4 }
  entity = EntityPrototypes.build(:potion)

  assert.has_attributes! entity, char: '!',
                                 color: [200, 200, 200],
                                 blocks_movement?: false,
                                 render_order: RenderOrder::ITEM

  assert.has_attributes! entity.consumable, amount: 4
end
