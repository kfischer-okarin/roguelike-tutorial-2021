module Entity
  class Actor < BaseEntity
    def combatant
      @combatant ||= Components::Combatant.new(self, data.combatant)
    end

    def ai
      @ai ||= Components::AI.from(self, data.ai)
    end

    def replace_ai(ai_data)
      data.ai = ai_data
      @ai = nil
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
      replace_ai(type: :none, data: {})
      self.name = "remains of #{name}"

      $message_log.add_message(text: message, fg: death_message_color)
      add_own_xp_to_player_xp
    end

    def reset_reference
      super
      @combatant = nil
      @ai = nil
    end

    def attack_message_color
      Colors.enemy_attack
    end

    def child_entities
      inventory.items
    end

    protected

    def death_message
      "#{name} is dead!"
    end

    def death_message_color
      Colors.enemy_death
    end

    def add_own_xp_to_player_xp
      $game.player.level.add_xp data.received_xp
    end
  end
end
