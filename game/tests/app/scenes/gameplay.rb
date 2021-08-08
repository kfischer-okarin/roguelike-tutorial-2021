require 'tests/test_helper.rb'

def test_gameplay_scene_ai_impossible_actions_are_ignored(args, assert)
  TestHelper.init_globals(args)
  player = EntityPrototypes.build(:player)
  other_entity = TestHelper.build_actor
  other_entity.define_singleton_method :ai do
    TestHelper.stub(perform_action: -> { raise Action::Impossible, 'Something went wrong' })
  end

  game_map = TestHelper.build_map_with_entities(
    [5, 5] => player,
    [1, 1] => other_entity
  )
  scene = Scenes::Gameplay.new(player: player, game_map: game_map)

  assert.raises_no_exception! do
    scene.after_action_performed
  end
end
