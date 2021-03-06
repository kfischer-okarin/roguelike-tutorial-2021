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

def test_gameplay_interact_on_item_picks_up_item(_args, assert)
  $game.game_map = build_game_map_with_entities(
    [2, 2] => [Entities.player, build_item]
  )

  assert.will_produce_action!(
    { type: :interact },
    PickupAction.new(Entities.player)
  )
end

def test_gameplay_interact_on_portal_location_enters_portall(_args, assert)
  $game.game_map = build_game_map(width: 10, height: 10, portal_location: [5, 5])
  Entities.player.place($game.game_map, x: 5, y: 5)

  assert.will_produce_action!(
    { type: :interact },
    EnterPortalAction.new(Entities.player)
  )
end

def test_gameplay_interact_on_empty_does_nothing(_args, assert)
  $game.game_map = build_game_map_with_entities(Entities.player)

  assert.will_produce_no_action!({ type: :interact })
end

def test_gameplay_enter_portal_action(_args, assert)
  $game.game_map = build_game_map_with_entities(Entities.player)

  assert.will_produce_action!(
    { type: :enter_portal },
    EnterPortalAction.new(Entities.player)
  )
end
