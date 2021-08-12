require 'tests/test_helper.rb'

def test_position_selection_success(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  previous_scene = TestHelper::Spy.new
  $game.push_scene previous_scene
  selected_position = nil
  position_action = TestHelper::Spy.new
  $game.game_map = build_game_map(20, 20)
  Entities.player.place($game.game_map, x: 3, y: 3)
  scene = Scenes::PositionSelection.new(previous_scene) do |position|
    selected_position = position
    position_action
  end

  scene.handle_input_events(
    [
      { type: :right },
      { type: :down },
      { type: :confirm }
    ]
  )

  assert.equal! selected_position, [4, 2]
  assert.includes! position_action.calls, [:perform, []]
  assert.equal! pop_scene_calls.size, 1
  assert.includes! previous_scene.calls, [:after_action_performed, []]
end

def test_position_selection_cannot_select_outside_map(_args, assert)
  $game.game_map = build_game_map(20, 20)
  Entities.player.place($game.game_map, x: 1, y: 18)
  selected_position = nil
  scene = Scenes::PositionSelection.new(nil) do |position|
    selected_position = position
    nil
  end

  scene.handle_input_events(
    [
      { type: :up },
      { type: :up },
      { type: :left },
      { type: :left },
      { type: :right },
      { type: :confirm }
    ]
  )

  assert.equal! selected_position, [1, 19]
end

def test_position_selection_quit_input_returns_to_previous_scene(_args, assert)
  pop_scene_calls = mock_method($game, :pop_scene)
  previous_scene = TestHelper::Spy.new
  $game.push_scene previous_scene
  selected_position = nil
  game_map = build_game_map(20, 20)
  Entities.player.place(game_map, x: 3, y: 3)
  scene = Scenes::PositionSelection.new(previous_scene) do |position|
    selected_position = position
  end

  scene.handle_input_events(
    [
      { type: :quit }
    ]
  )

  assert.equal! selected_position, nil
  assert.equal! pop_scene_calls.size, 1
  assert.true! previous_scene.calls.empty?
end
