require 'tests/test_helper.rb'

def test_item_has_ai_according_to_type(_args, assert)
  no_ai_entity = build_actor(ai: { type: :none })
  enemy_ai_entity = build_actor(ai: { type: :enemy })
  confused_ai_entity = build_actor(ai: { type: :confused })

  assert.equal! no_ai_entity.ai, Components::AI::None
  assert.equal! enemy_ai_entity.ai.class, Components::AI::Enemy
  assert.equal! confused_ai_entity.ai.class, Components::AI::Confused
end