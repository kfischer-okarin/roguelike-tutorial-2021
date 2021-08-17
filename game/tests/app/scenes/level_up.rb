require 'tests/test_helper.rb'

def test_level_up_first_choice_will_increases_max_hp(_args, assert)
  previous_scene = $game.scene
  $game.push_scene Scenes::LevelUp.new

  with_mocked_method $game.player.level, :increase_max_hp do |increase_max_hp_calls|
    assert.will_change_scene_to! previous_scene do
      $game.handle_input_events(
        [
          { type: :char_typed, char: 'a' }
        ]
      )
    end

    assert.equal! increase_max_hp_calls.size, 1
  end

  # Mouse
  $game.push_scene Scenes::LevelUp.new
  $game.cursor_position = [10, 40] # first item

  with_mocked_method $game.player.level, :increase_max_hp do |increase_max_hp_calls|
    assert.will_change_scene_to! previous_scene do
      $game.handle_input_events(
        [
          { type: :click }
        ]
      )
    end

    assert.equal! increase_max_hp_calls.size, 1
  end
end

def test_level_up_second_choice_will_increases_power(_args, assert)
  previous_scene = $game.scene
  $game.push_scene Scenes::LevelUp.new

  with_mocked_method $game.player.level, :increase_power do |increase_power_calls|
    assert.will_change_scene_to! previous_scene do
      $game.handle_input_events(
        [
          { type: :char_typed, char: 'b' }
        ]
      )
    end

    assert.equal! increase_power_calls.size, 1
  end

  # Mouse
  $game.push_scene Scenes::LevelUp.new
  $game.cursor_position = [10, 39] # second item

  with_mocked_method $game.player.level, :increase_power do |increase_power_calls|
    assert.will_change_scene_to! previous_scene do
      $game.handle_input_events(
        [
          { type: :click }
        ]
      )
    end

    assert.equal! increase_power_calls.size, 1
  end
end

def test_level_up_third_choice_will_increases_defense(_args, assert)
  previous_scene = $game.scene
  $game.push_scene Scenes::LevelUp.new

  with_mocked_method $game.player.level, :increase_defense do |increase_defense_calls|
    assert.will_change_scene_to! previous_scene do
      $game.handle_input_events(
        [
          { type: :char_typed, char: 'c' }
        ]
      )
    end

    assert.equal! increase_defense_calls.size, 1
  end

  # Mouse
  $game.push_scene Scenes::LevelUp.new
  $game.cursor_position = [10, 38] # third item

  with_mocked_method $game.player.level, :increase_defense do |increase_defense_calls|
    assert.will_change_scene_to! previous_scene do
      $game.handle_input_events(
        [
          { type: :click }
        ]
      )
    end

    assert.equal! increase_defense_calls.size, 1
  end
end

def test_level_up_other_input_will_do_nothing(_args, assert)
  $game.push_scene Scenes::LevelUp.new

  assert.will_not_change_scene! do
    $game.handle_input_events(
      [
        { type: :char_typed, char: 'd' }
      ]
    )
  end
end
