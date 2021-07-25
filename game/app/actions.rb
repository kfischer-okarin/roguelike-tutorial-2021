# Quits the game
module EscapeAction
  def self.perform(game, _entity)
    game.quit
  end
end

class ActionWithDirection
  def initialize(dx, dy)
    @dx = dx
    @dy = dy
  end
end

class BumpIntoEntityAction < ActionWithDirection
  def perform(game, entity)
    dest_x = entity.x + @dx
    dest_y = entity.y + @dy
    return MeleeAction.new(@dx, @dy).perform(game, entity) if game.game_map.blocking_entity_at(dest_x, dest_y)

    MovementAction.new(@dx, @dy).perform(game, entity)
  end
end

# Attacks another entity
class MeleeAction < ActionWithDirection
  def perform(game, entity)
    game_map = game.game_map
    dest_x = entity.x + @dx
    dest_y = entity.y + @dy

    target = game_map.blocking_entity_at(dest_x, dest_y)
    return unless target

    puts "You kick the #{target.name}, much to its annoyance!"
  end
end

# Moves the player
class MovementAction < ActionWithDirection
  def perform(game, entity)
    game_map = game.game_map
    dest_x = entity.x + @dx
    dest_y = entity.y + @dy

    return unless game_map.in_bounds?(dest_x, dest_y)
    return unless game_map.walkable?(dest_x, dest_y)

    Entity.move(entity, dx: @dx, dy: @dy)
  end
end
