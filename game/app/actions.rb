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
    Entity.move(args.state.player, dx: @dx, dy: @dy)
  end
end
