require 'tests/test_helper.rb'

def test_position_selection_success(_args, assert)
  previous_scene = $game.scene
  selected_position = nil
  position_action = TestHelper::Mock.new
  position_action.expect_call :perform
  $game.game_map = build_game_map(20, 20)
  Entities.player.place($game.game_map, x: 3, y: 3)
  scene = Scenes::PositionSelection.new(previous_scene) do |position|
    selected_position = position
    position_action
  end
  $game.push_scene scene

  assert.will_advance_turn! do
    $game.handle_input_events(
      [
        { type: :right },
        { type: :down },
        { type: :confirm }
      ]
    )
  end

  assert.equal! selected_position, [4, 2]
  position_action.assert_all_calls_received!(assert)
  assert.equal! $game.scene, previous_scene
end

def test_position_selection_cannot_select_outside_map(_args, assert)
  $game.game_map = build_game_map(20, 20)
  Entities.player.place($game.game_map, x: 1, y: 18)
  selected_position = nil
  scene = Scenes::PositionSelection.new(nil) do |position|
    selected_position = position
    nil
  end
  $game.push_scene scene

  $game.handle_input_events(
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
  previous_scene = $game.scene
  selected_position = nil
  game_map = build_game_map(20, 20)
  Entities.player.place(game_map, x: 3, y: 3)
  scene = Scenes::PositionSelection.new(previous_scene) do |position|
    selected_position = position
  end
  $game.push_scene scene

  assert.will_not_advance_turn! do
    $game.handle_input_events(
      [
        { type: :quit }
      ]
    )
  end

  assert.equal! selected_position, nil
  assert.equal! $game.scene, previous_scene
end
