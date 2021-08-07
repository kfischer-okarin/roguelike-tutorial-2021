require 'tests/test_helper.rb'

def test_entities_setup(args, assert)
  TestHelper.init_globals(args)
  entity = Entity::BaseEntity.new(:entity, some_data: 5)
  Entities << entity

  assert.equal! Entities.each.to_a, [entity]

  Entities.setup(args.state)

  assert.equal! Entities.each.to_a, []
end
