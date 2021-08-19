module Entity
  class Item < BaseEntity
    def consumable
      @consumable ||= Components::Consumable.from(self, data.consumable)
    end

    def equippable
      @equippable ||= Components::Equippable.new(self, data.equippable) if data.equippable
    end

    def activate(user)
      consumable.activate(user) if consumable
    end

    def get_action(user)
      consumable.get_action(user) if consumable
    end

    def reset_reference
      super
      @consumable = nil
      @equippable = nil
    end
  end
end
