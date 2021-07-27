module Entity
  class Actor < BaseEntity
    def combatant
      @combatant ||= Components::Combatant.new(self, data.combatant)
    end

    def reset_reference
      super
      @combatant = nil
    end
  end
end
