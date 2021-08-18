require 'tests/test_helper.rb'

def test_parameters_by_floor_max_items(_args, assert)
  parameters_by_floor = TestParametersByFloor.build_parameters_by_foor(
    max_items_per_room: {
      1 => 1,
      3 => 2
    }
  )

  assert.has_attributes! parameters_by_floor.for_floor(1), max_items_per_room: 1
  assert.has_attributes! parameters_by_floor.for_floor(2), max_items_per_room: 1
  assert.has_attributes! parameters_by_floor.for_floor(3), max_items_per_room: 2
end

def test_parameters_by_floor_max_monsters(_args, assert)
  parameters_by_floor =  TestParametersByFloor.build_parameters_by_foor(
    max_monsters_per_room: {
      1 => 1,
      3 => 2
    }
  )

  assert.has_attributes! parameters_by_floor.for_floor(1), max_monsters_per_room: 1
  assert.has_attributes! parameters_by_floor.for_floor(2), max_monsters_per_room: 1
  assert.has_attributes! parameters_by_floor.for_floor(3), max_monsters_per_room: 2
end

module TestParametersByFloor
  def self.build_parameters_by_foor(values)
    GameWorld::ParametersByFloor.new(
      max_items_per_room: values[:max_items_per_room] || { 1 => 1 },
      max_monsters_per_room: values[:max_monsters_per_room] || { 1 => 1 }
    )
  end
end
