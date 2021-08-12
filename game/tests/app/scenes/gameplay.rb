require 'tests/test_helper.rb'

def test_gameplay_scene_ai_impossible_actions_are_ignored(_args, assert)
  player = build_player
  other_entity = build_actor
  error_ai = stub(perform_action: -> { raise Action::Impossible, 'Something went wrong' })
  stub_attribute(other_entity, :ai, error_ai)

  $game.game_map = build_game_map_with_entities(
    [5, 5] => player,
    [1, 1] => other_entity
  )
  scene = Scenes::Gameplay.new(player: player)

  assert.raises_no_exception! do
    scene.after_action_performed
  end
end
