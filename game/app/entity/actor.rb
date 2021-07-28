module Entity
  class Actor < BaseEntity
    def combatant
      @combatant ||= Components::Combatant.new(self, data.combatant)
    end

    def ai
      @ai ||= build_ai
    end

    def alive?
      !combatant.dead?
    end

    def die
      message = death_message
      self.char = '%'
      self.color = [191, 0, 0]
      self.blocks_movement = false
      @ai = Components::AI::None
      self.name = "remains of #{name}"

      puts(message)
    end

    def reset_reference
      super
      @combatant = nil
      @ai = nil
    end

    protected

    def death_message
      "#{name} is dead!"
    end

    def build_ai
      return Components::AI::None if combatant.dead?

      Components::AI::Enemy.new(self)
    end
  end
end
