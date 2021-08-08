require 'tests/test_helper.rb'

def test_entities_setup_resets_entities(args, assert)
  TestHelper.init_globals(args)
  TestHelper.build_entity

  Entities.setup(args.state)

  assert.equal! Entities.each.to_a, []
end

def test_entities_add(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.build_entity

  assert.equal! Entities.each.to_a, [entity]
end

def test_entities_get(args, assert)
  TestHelper.init_globals(args)
  entity = TestHelper.build_entity

  assert.equal! Entities.get(entity.id), entity
end
