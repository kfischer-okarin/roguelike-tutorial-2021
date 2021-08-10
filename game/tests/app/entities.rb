require 'tests/test_helper.rb'

def test_entities_setup_resets_entities(args, assert)
  TestHelper.build_entity

  Entities.setup(args.state)

  assert.equal! Entities.each.to_a, []
end

def test_entities_add(_args, assert)
  entity = TestHelper.build_entity

  assert.includes! Entities.each, entity
end

def test_entities_get(_args, assert)
  entity = TestHelper.build_entity

  assert.equal! Entities.get(entity.id), entity
end
