require 'tests/test_helper.rb'

def test_confused_goes_to_random_direction(_args, assert)
  actor = build_actor(
    ai: { type: :confused, data: { turns: 2 } }
  )
  build_game_map_with_entities(
    [3, 3] => actor
  )
  rng = TestHelper::Mock.new
  stub_attribute($game, :rng, rng)
  rng.expect_call :random_element_from, args: [Components::AI::Confused::DIRECTIONS], return_value: [1, 0]

  actor.ai.perform_action

  rng.assert_all_calls_received!(assert)
  assert.has_attributes! actor, x: 4, y: 3
  assert.equal! actor.ai.turns, 1
end

def test_confused_returns_to_old_ai_afterwards(_args, assert)
  actor = build_actor(
    name: 'Knight',
    ai: { type: :confused, data: { turns: 0, previous_ai: { type: :enemy, data: {} } } }
  )

  actor.ai.perform_action

  assert.equal! actor.ai.class, Components::AI::Enemy
  assert.includes! log_messages, 'The Knight is no longer confused.'
end
