module Entity
  class Item < BaseEntity
    def consumable
      @consumable ||= Components::Consumable.from(self, data.consumable)
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
    end
  end
end
