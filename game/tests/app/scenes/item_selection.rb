require 'tests/test_helper.rb'

def test_item_selection_success(_args, assert)
  previous_scene = $game.scene
  item1 = build_item
  item2 = build_item
  actor = build_actor items: [item1, item2]
  selected_item = nil
  item_action = TestHelper::Mock.new
  item_action.expect_call :perform
  scene = Scenes::ItemSelection.new(inventory: actor.inventory) do |item|
    selected_item = item
    item_action
  end
  $game.push_scene scene

  assert.will_advance_turn! do
    $game.handle_input_events(
      [
        { type: :char_typed, char: 'b' }
      ]
    )
  end

  assert.equal! selected_item, item2
  item_action.assert_all_calls_received!(assert)
  assert.equal! $game.scene, previous_scene
end

def test_item_selection_via_click(_args, assert)
  previous_scene = $game.scene
  item1 = build_item
  item2 = build_item
  actor = build_actor items: [item1, item2]
  selected_item = nil
  item_action = TestHelper::Mock.new
  item_action.expect_call :perform
  scene = Scenes::ItemSelection.new(inventory: actor.inventory) do |item|
    selected_item = item
    item_action
  end
  $game.push_scene scene
  $game.cursor_position = [10, 43] # first item

  assert.will_advance_turn! do
    $game.handle_input_events(
      [
        { type: :click }
      ]
    )
  end

  assert.equal! selected_item, item1
  item_action.assert_all_calls_received!(assert)
  assert.equal! $game.scene, previous_scene
end

def test_item_selection_cannot_select_non_existing_item(_args, assert)
  actor = build_actor items: [build_item, build_item]
  selected_item = nil
  scene = Scenes::ItemSelection.new(inventory: actor.inventory) do |item|
    selected_item = item
  end
  $game.push_scene scene

  assert.will_not_advance_turn! do
    $game.handle_input_events(
      [
        { type: :char_typed, char: 'c' }
      ]
    )
  end

  assert.equal! selected_item, nil
  assert.equal! $game.scene, scene
end

def test_item_selection_quit_input_returns_to_previous_scene(_args, assert)
  previous_scene = $game.scene
  actor = build_actor items: [build_item, build_item]
  selected_item = nil
  scene = Scenes::ItemSelection.new(inventory: actor.inventory) do |item|
    selected_item = item
  end
  $game.push_scene scene

  assert.will_not_advance_turn! do
    $game.handle_input_events(
      [
        { type: :quit }
      ]
    )
  end

  assert.equal! selected_item, nil
  assert.equal! $game.scene, previous_scene
end
