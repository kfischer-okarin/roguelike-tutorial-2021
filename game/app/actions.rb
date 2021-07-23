# Quits the game
module EscapeAction
  def self.execute(_entities)
    $gtk.request_quit
  end
end

# Moves the player
class MovementAction
  def initialize(dx, dy)
    @dx = dx
    @dy = dy
  end

  def execute(entities)
    Entity.move(entities.player, dx: @dx, dy: @dy)
  end
end
