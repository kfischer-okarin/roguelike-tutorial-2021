require 'tests/test_helper.rb'

def test_item_selection_success(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  previous_scene = TestHelper::Spy.new
  $game.push_scene previous_scene
  item1 = build_item
  item2 = build_item
  actor = build_actor items: [item1, item2]
  selected_item = nil
  item_action = TestHelper::Mock.new
  item_action.expect_call :perform
  scene = Scenes::ItemSelection.new(previous_scene, inventory: actor.inventory) do |item|
    selected_item = item
    item_action
  end

  scene.handle_input_events(
    [
      { type: :char_typed, char: 'b' }
    ]
  )

  assert.equal! selected_item, item2
  item_action.assert_all_calls_received!(assert)
  assert.equal! pop_scene_calls.size, 1
  assert.includes! previous_scene.calls, [:after_action_performed, []]
end

def test_item_selection_via_click(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  previous_scene = TestHelper::Spy.new
  $game.push_scene previous_scene
  item1 = build_item
  item2 = build_item
  actor = build_actor items: [item1, item2]
  selected_item = nil
  item_action = TestHelper::Mock.new
  item_action.expect_call :perform
  scene = Scenes::ItemSelection.new(previous_scene, inventory: actor.inventory) do |item|
    selected_item = item
    item_action
  end
  $game.cursor_position = [10, 43] # first item

  scene.handle_input_events(
    [
      { type: :click }
    ]
  )

  assert.equal! selected_item, item1
  item_action.assert_all_calls_received!(assert)
  assert.equal! pop_scene_calls.size, 1
  assert.includes! previous_scene.calls, [:after_action_performed, []]
end

def test_item_selection_cannot_selected_non_existing_item(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  actor = build_actor items: [build_item, build_item]
  selected_item = nil
  scene = Scenes::ItemSelection.new(nil, inventory: actor.inventory) do |item|
    selected_item = item
  end

  scene.handle_input_events(
    [
      { type: :char_typed, char: 'c' }
    ]
  )

  assert.equal! selected_item, nil
  assert.true! pop_scene_calls.empty?
end

def test_item_selection_non_item_input_returns_to_previous_scene(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  previous_scene = TestHelper::Spy.new
  $game.push_scene previous_scene
  actor = build_actor items: [build_item, build_item]
  selected_item = nil
  scene = Scenes::ItemSelection.new(previous_scene, inventory: actor.inventory) do |item|
    selected_item = item
  end

  scene.handle_input_events(
    [
      { type: :char_typed, char: '3' }
    ]
  )

  assert.equal! selected_item, nil
  assert.equal! pop_scene_calls.size, 1
  assert.true! previous_scene.calls.empty?
end

def test_item_selection_quit_input_returns_to_previous_scene(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  previous_scene = TestHelper::Spy.new
  $game.push_scene previous_scene
  actor = build_actor items: [build_item, build_item]
  selected_item = nil
  scene = Scenes::ItemSelection.new(previous_scene, inventory: actor.inventory) do |item|
    selected_item = item
  end

  scene.handle_input_events(
    [
      { type: :quit }
    ]
  )

  assert.equal! selected_item, nil
  assert.equal! pop_scene_calls.size, 1
  assert.true! previous_scene.calls.empty?
end
