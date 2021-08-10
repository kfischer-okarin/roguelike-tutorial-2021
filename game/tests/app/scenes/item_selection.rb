require 'tests/test_helper.rb'

def test_item_selection_success(_args, assert)
  previous_scene = TestHelper::Spy.new
  potion = TestHelper.build_item('Potion')
  bomb = TestHelper.build_item('Bomb')
  inventory = TestHelper.build_inventory(items: [potion, bomb])
  selected_item = nil
  item_action = TestHelper::Spy.new
  scene = Scenes::ItemSelection.new(previous_scene, inventory: inventory) do |item|
    selected_item = item
    item_action
  end

  scene.handle_input_events(
    [
      { type: :char_typed, char: 'b' }
    ]
  )

  assert.equal! selected_item, bomb
  assert.includes! item_action.calls, [:perform, []]
  assert.includes! $game.calls, [:scene=, [previous_scene]]
  assert.includes! previous_scene.calls, [:after_action_performed, []]
end

def test_item_selection_cannot_selected_non_existing_item(_args, assert)
  potion = TestHelper.build_item('Potion')
  bomb = TestHelper.build_item('Bomb')
  inventory = TestHelper.build_inventory(items: [potion, bomb])
  selected_item = nil
  scene = Scenes::ItemSelection.new(nil, inventory: inventory) do |item|
    selected_item = item
  end

  scene.handle_input_events(
    [
      { type: :char_typed, char: 'c' }
    ]
  )

  assert.equal! selected_item, nil
  assert.true! $game.calls.empty?
end

def test_item_selection_non_item_input_returns_to_previous_scene(_args, assert)
  previous_scene = TestHelper::Spy.new
  potion = TestHelper.build_item('Potion')
  bomb = TestHelper.build_item('Bomb')
  inventory = TestHelper.build_inventory(items: [potion, bomb])
  selected_item = nil
  scene = Scenes::ItemSelection.new(previous_scene, inventory: inventory) do |item|
    selected_item = item
  end

  scene.handle_input_events(
    [
      { type: :char_typed, char: '3' }
    ]
  )

  assert.equal! selected_item, nil
  assert.includes! $game.calls, [:scene=, [previous_scene]]
  assert.true! previous_scene.calls.empty?
end

def test_item_selection_quit_input_returns_to_previous_scene(_args, assert)
  previous_scene = TestHelper::Spy.new
  potion = TestHelper.build_item('Potion')
  bomb = TestHelper.build_item('Bomb')
  inventory = TestHelper.build_inventory(items: [potion, bomb])
  selected_item = nil
  scene = Scenes::ItemSelection.new(previous_scene, inventory: inventory) do |item|
    selected_item = item
  end

  scene.handle_input_events(
    [
      { type: :quit }
    ]
  )

  assert.equal! selected_item, nil
  assert.includes! $game.calls, [:scene=, [previous_scene]]
  assert.true! previous_scene.calls.empty?
end
