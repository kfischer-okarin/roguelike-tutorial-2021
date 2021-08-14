require 'tests/test_helper.rb'

def test_game_turn_is_advanced_after_action(_args, assert)
  $game.game_map = build_game_map_with_entities(Entities.player, build_actor)
  $game.scene = Scenes::Gameplay.new(player: Entities.player)
  scene_before = $game.scene

  assert.will_advance_turn! do
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

  assert.will_not_advance_turn! do
    $game.handle_input_events [
      { type: :inventory }
    ]
  end
  assert.not_equal! $game.scene, scene_before
end

def test_game_log_impossible_actions(_args, assert)
  $game.scene = GameTests.build_test_scene
  $game.scene.next_action = -> { raise Action::Impossible, 'Something did not work.' }

  $game.handle_input_events [{ type: :test }]

  assert.includes! log_messages, 'Something did not work.'
end

def test_game_generate_next_floor_deletes_all_non_player_related_entities(_args, assert)
  owned_item = build_item
  owned_item.place(Entities.player.inventory)
  other_item = build_item
  enemy_owned_item = build_item
  enemy = build_actor(items: [enemy_owned_item])
  $game.game_map = build_game_map_with_entities(Entities.player, other_item, enemy)
  generated_game_map = nil
  generate_dungeon_stub = lambda { |*_args|
    generated_game_map = build_game_map_with_entities(Entities.player)
  }

  with_replaced_method Procgen, :generate_dungeon, generate_dungeon_stub do
    $game.generate_next_floor
  end

  assert.includes_all! Entities, [Entities.player, owned_item]
  assert.includes_none_of! Entities, [other_item, enemy, enemy_owned_item]
  assert.equal! $game.game_map, generated_game_map
end

module GameTests
  class << self
    def build_test_scene
      scene_class = Class.new(Scenes::BaseScene) do
        def next_action=(action_lambda)
          replace_method self, :handle_input_event do |_|
            stub(perform: action_lambda)
          end
        end
      end

      scene_class.new
    end
  end
end

