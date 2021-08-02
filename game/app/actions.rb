class Action
  def initialize(entity)
    @entity = entity
  end
end

module WaitAction
  def self.perform
    # no op
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

  def target_actor
    @entity.game_map.actor_at(dest_x, dest_y)
  end
end

class BumpIntoEntityAction < ActionWithDirection
  def perform
    return MeleeAction.new(@entity, dx: @dx, dy: @dy).perform if target_actor

    MovementAction.new(@entity, dx: @dx, dy: @dy).perform
  end
end

# Attacks another entity
class MeleeAction < ActionWithDirection
  def perform
    target = target_actor
    return unless target

    damage = @entity.combatant.power - target.combatant.defense
    attack_description = "#{@entity.name} attacks #{target_actor.name}"
    message_color = @entity.attack_message_color
    if damage.positive?
      $message_log.add_message(text: "#{attack_description} for #{damage} hit points.", fg: message_color)
      target.combatant.hp -= damage
    else
      $message_log.add_message(text: "#{attack_description} but does no damage.", fg: message_color)
    end
  end
end

# Moves the player
class MovementAction < ActionWithDirection
  def perform
    game_map = @entity.game_map
    return unless game_map.in_bounds?(dest_x, dest_y)
    return unless game_map.walkable?(dest_x, dest_y)

    @entity.move(@dx, @dy)
  end
end
