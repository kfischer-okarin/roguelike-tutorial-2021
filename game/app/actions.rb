class Action
  class Impossible < StandardError; end

  def initialize(entity)
    @entity = entity
  end

  def ==(other)
    return false unless self.class == other.class

    instance_variables.all? { |var| instance_variable_get(var) == other.instance_variable_get(var) }
  end
end

module WaitAction
  def self.perform
    # no op
  end
end

class PickupAction < Action
  def perform
    item = items_at_own_position.first
    raise Action::Impossible, 'There is nothing to pick up.' unless item

    item.place(@entity.inventory)
    $message_log.add_message(text: "You picked up the #{item.name}!")
  end

  private

  def items_at_own_position
    @entity.game_map.items_at(@entity.x, @entity.y)
  end
end

class UseItemAction < Action
  def initialize(entity, item)
    super(entity)
    @item = item
  end

  def perform
    @item.consumable.activate @entity
  end
end

class UseItemOnPositionAction < Action
  def initialize(entity, item, position:)
    super(entity)
    @item = item
    @position = position
  end

  def perform
    @item.consumable.activate @entity, @position
  end
end

class DropItemAction < Action
  def initialize(entity, item)
    super(entity)
    @item = item
  end

  def perform
    @entity.inventory.drop @item
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
    raise Action::Impossible, 'Nothing to attack.' unless target

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
    raise Action::Impossible, 'That way is blocked.' unless game_map.in_bounds?(dest_x, dest_y)
    raise Action::Impossible, 'That way is blocked.' unless game_map.walkable?(dest_x, dest_y)

    @entity.move(@dx, @dy)
  end
end
