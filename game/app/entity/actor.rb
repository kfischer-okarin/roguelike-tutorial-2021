module Entity
  class Actor < BaseEntity
    def combatant
      @combatant ||= Components::Combatant.new(self, data.combatant)
    end

    def ai
      @ai ||= build_ai
    end

    def reset_reference
      super
      @combatant = nil
      @ai = nil
    end

    protected

    def build_ai
      Components::AI::Enemy.new(self)
    end
  end
end
