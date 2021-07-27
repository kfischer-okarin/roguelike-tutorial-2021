module Entity
  class Actor < BaseEntity
    def combatant
      @combatant ||= Components::Combatant.new(self, data.combatant)
    end

    def ai
      @ai ||= case data.ai
              when :enemy
                Components::AI::Enemy.new(self)
              when :none
                Components::AI::None
              end
    end

    def reset_reference
      super
      @combatant = nil
    end
  end
end
