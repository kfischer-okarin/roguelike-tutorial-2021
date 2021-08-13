require 'tests/test_helper.rb'

def test_game_turn_is_advanced_after_action(_args, assert)
  $game.game_map = build_game_map_with_entities(Entities.player, build_actor)
  $game.scene = Scenes::Gameplay.new(player: Entities.player)
  scene_before = $game.scene

  GameTests.assert_will_advance_turn!(assert) do
    $game.handle_input_events [
      { type: :wait }
    ]
  end
  assert.equal! $game.scene, scene_before, 'Scene changed'
end

def test_game_turn_is_not_advanced_after_opening_ui(_args, assert)
  $game.game_map = build_game_map_with_entities(Entities.player, build_actor)
  $game.scene = Scenes::Gameplay.new(player: Entities.player)
  scene_before = $game.scene

  GameTests.assert_will_not_advance_turn!(assert) do
    $game.handle_input_events [
      { type: :inventory }
    ]
  end
  assert.not_equal! $game.scene, scene_before
end

module GameTests
  class << self
    def any_enemy_from(game_map)
      game_map.actors.find { |actor| actor.ai != Components::AI::None }
    end

    def assert_will_advance_turn!(assert)
      an_enemy = any_enemy_from($game.game_map)
      ai_calls = mock_method an_enemy.ai, :perform_action
      update_fov_calls = mock_method $game.game_map, :update_fov

      yield

      assert.equal! ai_calls.size, 1, 'AI was not called'
      assert.equal! update_fov_calls.size, 1, 'FOV was not updated'
    end

    def assert_will_not_advance_turn!(assert)
      an_enemy = any_enemy_from($game.game_map)
      ai_calls = mock_method an_enemy.ai, :perform_action
      update_fov_calls = mock_method $game.game_map, :update_fov

      yield

      assert.equal! ai_calls.size, 0, 'AI was called'
      assert.equal! update_fov_calls.size, 0, 'FOV was updated'
    end
  end
end

