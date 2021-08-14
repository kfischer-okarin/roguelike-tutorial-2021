require 'tests/test_helper.rb'

def test_main_menu_new_game(_args, assert)
  player_before = Entities.player
  $game.scene = Scenes::MainMenu.new
  generated_game_map = nil
  generate_dungeon_stub = lambda { |*_args|
    generated_game_map = build_game_map_with_entities(Entities.player)
  }

  with_replaced_method Procgen, :generate_dungeon, generate_dungeon_stub do
    assert.will_change_scene_to! Scenes::Gameplay do
      $game.handle_input_events([{ type: :main_menu_new_game }])
    end
  end

  assert.not_equal! Entities.player, player_before, 'No new player was generated'
  assert.equal! Entities.to_a, [Entities.player]
  assert.not_equal! generated_game_map, nil, 'No map was generated'
  assert.equal! $game.game_map, generated_game_map
end
