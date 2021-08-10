require 'tests/test_helper.rb'
require 'tests/app/entity/base_entity.rb'
require 'tests/app/entity/item.rb'

def test_entity_build_returns_different_ids_for_each_entity(_args, assert)
  entity = Entity.build(:fly, hp: 3)

  assert.true! entity.is_a?(Entity::BaseEntity)

  another_entity = Entity.build(:fly, hp: 3)

  assert.not_equal! entity.id, another_entity.id
end

def test_entity_build_registers_entity_in_entities(_args, assert)
  entity = Entity.build(:robot, hp: 999)

  assert.includes! Entities, entity
end

def test_entity_from_returns_player_for_entity_type_player(_args, assert)
  data = $state.new_entity_strict(:player, combatant: { hp: 22 })

  entity = Entity.from(data)

  assert.equal! entity.class, Entity::Player
end

def test_entity_from_returns_actor_for_data_with_combatant(_args, assert)
  data = $state.new_entity_strict(:enemy, combatant: { hp: 22 })

  entity = Entity.from(data)

  assert.equal! entity.class, Entity::Actor
end

def test_entity_from_returns_item_for_data_with_consumable(_args, assert)
  data = $state.new_entity_strict(:item, consumable: { amount: 22 })

  entity = Entity.from(data)

  assert.equal! entity.class, Entity::Item
end

def test_entity_from_returns_base_entity_for_unknown_data(_args, assert)
  data = $state.new_entity_strict(:somebody, unknown_stuff: 'abc')

  entity = Entity.from(data)

  assert.equal! entity.class, Entity::BaseEntity
end
