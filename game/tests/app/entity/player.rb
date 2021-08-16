require 'tests/test_helper.rb'

def test_player_die_adds_no_xp_to_player_xp(_args, assert)
  $game.player.level.current_xp = 20

  $game.player.die

  assert.equal! $game.player.level.current_xp, 20
end
