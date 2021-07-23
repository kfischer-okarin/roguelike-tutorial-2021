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
    player = entities.player
    return unless $game.game_map.walkable?(player.x + @dx, player.y + @dy)

    Entity.move(player, dx: @dx, dy: @dy)
  end
end
