require 'tests/test_helper.rb'

def test_entities_add(_args, assert)
  entity = build_entity

  assert.includes! Entities.each, entity
end

def test_entities_get(_args, assert)
  entity = build_entity

  assert.equal! Entities.get(entity.id), entity
end
