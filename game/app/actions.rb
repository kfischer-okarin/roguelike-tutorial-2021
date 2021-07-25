class Action
  def initialize(entity)
    @entity = entity
  end
end

# Quits the game
module EscapeAction
  def self.perform
    $game.quit
  end
end

class ActionWithDirection < Action
  def initialize(entity, dx:, dy:)
    super(entity)
    @dx = dx
    @dy = dy
  end

  def dest_x
    @entity.x + @dx
  end

  def dest_y
    @entity.y + @dy
  end
end

class BumpIntoEntityAction < ActionWithDirection
  def perform
    return MeleeAction.new(@entity, dx: @dx, dy: @dy).perform if @entity.game_map.blocking_entity_at(dest_x, dest_y)

    MovementAction.new(@entity, dx: @dx, dy: @dy).perform
  end
end

# Attacks another entity
class MeleeAction < ActionWithDirection
  def perform
    target = @entity.game_map.blocking_entity_at(dest_x, dest_y)
    return unless target

    puts "You kick the #{target.name}, much to its annoyance!"
  end
end

# Moves the player
class MovementAction < ActionWithDirection
  def perform
    game_map = @entity.game_map
    return unless game_map.in_bounds?(dest_x, dest_y)
    return unless game_map.walkable?(dest_x, dest_y)

    Entity.move(@entity, dx: @dx, dy: @dy)
  end
end
