require 'tests/test_helper.rb'

def test_level_experience_to_next_level(_args, assert)
  player = build_player
  player.level.level_up_base = 0
  player.level.level_up_factor = 150
  player.level.current_level = 1

  assert.equal! player.level.experience_to_next_level, 150

  player.level.current_level = 2
  assert.equal! player.level.experience_to_next_level, 300
end

def test_level_requires_level_up(_args, assert)
  player = build_player
  player.level.current_xp = 140

  with_replaced_method player.level, :experience_to_next_level, -> { 150 } do
    assert.false! player.level.requires_level_up?

    player.level.current_xp = 150

    assert.true! player.level.requires_level_up?
  end
end

def test_level_add_xp_shows_xp_gained_message(_args, assert)
  player = build_player
  player.level.current_xp = 30

  player.level.add_xp 50

  assert.includes! log_messages, 'You gain 50 experience points.'
  assert.equal! player.level.current_xp, 80
end

def test_level_add_xp_shows_level_up_message_when_surpassing_needed_xp(_args, assert)
  player = build_player
  player.level.current_xp = 280
  player.level.current_level = 2

  with_replaced_method player.level, :experience_to_next_level, -> { 300 } do
    player.level.add_xp 30

    assert.includes! log_messages, 'You advance to level 3!'
  end
end

def test_level_increase_level(_args, assert)
  player = build_player
  # Level up XP 300
  player.level.level_up_base = 0
  player.level.level_up_factor = 150
  player.level.current_level = 2
  player.level.current_xp = 350

  player.level.increase_level

  assert.equal! player.level.current_level, 3
  assert.equal! player.level.current_xp, 50
end
