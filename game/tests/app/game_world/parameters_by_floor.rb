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

def test_parameters_by_floor_item_weights(_args, assert)
  parameters_by_floor =  TestParametersByFloor.build_parameters_by_foor(
    item_weights: {
      1 => { bandages: 35 },
      2 => { neurosonic_emitter: 10 },
      4 => { megavolt_capsule: 25 },
      6 => { grenade: 25 }
    }
  )

  assert.has_attributes! parameters_by_floor.for_floor(1), item_weights: { bandages: 35 }
  assert.has_attributes! parameters_by_floor.for_floor(2), item_weights: {
    bandages: 35, neurosonic_emitter: 10
  }
  assert.has_attributes! parameters_by_floor.for_floor(3), item_weights: {
    bandages: 35, neurosonic_emitter: 10
  }
  assert.has_attributes! parameters_by_floor.for_floor(4), item_weights: {
    bandages: 35, neurosonic_emitter: 10, megavolt_capsule: 25
  }
  assert.has_attributes! parameters_by_floor.for_floor(5), item_weights: {
    bandages: 35, neurosonic_emitter: 10, megavolt_capsule: 25
  }
  assert.has_attributes! parameters_by_floor.for_floor(6), item_weights: {
    bandages: 35, neurosonic_emitter: 10, megavolt_capsule: 25, grenade: 25
  }
end

def test_parameters_by_floor_monster_weights(_args, assert)
  parameters_by_floor =  TestParametersByFloor.build_parameters_by_foor(
    monster_weights: {
      1 => { mutant_spider: 80 },
      3 => { cyborg_bearman: 15 },
      5 => { cyborg_bearman: 30 },
      7 => { cyborg_bearman: 60 }
    }
  )

  assert.has_attributes! parameters_by_floor.for_floor(1), monster_weights: { mutant_spider: 80 }
  assert.has_attributes! parameters_by_floor.for_floor(2), monster_weights: { mutant_spider: 80 }
  assert.has_attributes! parameters_by_floor.for_floor(3), monster_weights: {
    mutant_spider: 80, cyborg_bearman: 15
  }
  assert.has_attributes! parameters_by_floor.for_floor(4), monster_weights: {
    mutant_spider: 80, cyborg_bearman: 15
  }
  assert.has_attributes! parameters_by_floor.for_floor(5), monster_weights: {
    mutant_spider: 80, cyborg_bearman: 30
  }
  assert.has_attributes! parameters_by_floor.for_floor(6), monster_weights: {
    mutant_spider: 80, cyborg_bearman: 30
  }
  assert.has_attributes! parameters_by_floor.for_floor(7), monster_weights: {
    mutant_spider: 80, cyborg_bearman: 60
  }
end

module TestParametersByFloor
  def self.build_parameters_by_foor(values)
    GameWorld::ParametersByFloor.new(
      max_items_per_room: values[:max_items_per_room] || { 1 => 1 },
      max_monsters_per_room: values[:max_monsters_per_room] || { 1 => 1 },
      item_weights: values[:item_weights] || { 1 => { bandages: 100 } },
      monster_weights: values[:monster_weights] || { 1 => { mutant_spider: 100 } }
    )
  end
end
