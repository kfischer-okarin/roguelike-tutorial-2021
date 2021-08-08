module Entity
  class Actor < BaseEntity
    def combatant
      @combatant ||= Components::Combatant.new(self, data.combatant)
    end

    def ai
      @ai ||= build_ai
    end

    def inventory
      @inventory ||= Components::Inventory.new(self, data.inventory)
    end

    def alive?
      !combatant.dead?
    end

    def die
      message = death_message
      self.char = '%'
      self.color = [191, 0, 0]
      self.render_order = RenderOrder::CORPSE
      self.blocks_movement = false
      @ai = Components::AI::None
      self.name = "remains of #{name}"

      $message_log.add_message(text: message, fg: death_message_color)
    end

    def reset_reference
      super
      @combatant = nil
      @ai = nil
    end

    def attack_message_color
      Colors.enemy_attack
    end

    protected

    def death_message
      "#{name} is dead!"
    end

    def death_message_color
      Colors.enemy_death
    end

    def build_ai
      return Components::AI::None if combatant.dead?

      Components::AI::Enemy.new(self)
    end
  end
end
