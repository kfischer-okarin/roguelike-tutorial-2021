# Quits the game
module EscapeAction
  def self.execute(_args)
    $gtk.request_quit
  end
end

# Moves the player
class MovementAction
  def initialize(dx, dy)
    @dx = dx
    @dy = dy
  end

  def execute(args)
    args.state.player_x += @dx
    args.state.player_y += @dy
  end
end
