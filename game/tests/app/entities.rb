require 'tests/test_helper.rb'

def test_entities_add(_args, assert)
  entity = build_entity

  assert.includes! Entities, entity
end

def test_entities_get(_args, assert)
  entity = build_entity

  assert.equal! Entities.get(entity.id), entity
end

def test_entities_delete_removes_children_too(_args, assert)
  item = build_item
  actor = build_actor(items: [item])

  Entities.delete actor

  assert.includes_none_of! Entities, [actor, item]
end
