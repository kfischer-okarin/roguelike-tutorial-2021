# Quits the game
module EscapeAction
  def self.perform(game, _entity)
    game.quit
  end
end

# Moves the player
class MovementAction
  def initialize(dx, dy)
    @dx = dx
    @dy = dy
  end

  def perform(game, entity)
    game_map = game.game_map
    dest_x = entity.x + @dx
    dest_y = entity.y + @dy

    return unless game_map.in_bounds?(dest_x, dest_y)
    return unless game_map.walkable?(dest_x, dest_y)

    Entity.move(entity, dx: @dx, dy: @dy)
  end
end
