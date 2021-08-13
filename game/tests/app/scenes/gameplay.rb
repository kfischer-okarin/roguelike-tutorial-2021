require 'tests/test_helper.rb'

def test_gameplay_scene_ai_impossible_actions_are_ignored(_args, assert)
  other_entity = build_actor
  error_ai = stub(perform_action: -> { raise Action::Impossible, 'Something went wrong' })
  stub_attribute(other_entity, :ai, error_ai)
  $game.game_map = build_game_map_with_entities(Entities.player, other_entity)
  $game.push_scene Scenes::Gameplay.new(player: Entities.player)

  assert.raises_no_exception! do
    $game.advance_turn
  end
end
