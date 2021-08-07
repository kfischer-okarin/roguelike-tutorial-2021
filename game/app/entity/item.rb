module Entity
  class Item < BaseEntity
    def consumable
      @consumable ||= Components::HealingConsumable.new(self, data.consumable)
    end

    def reset_reference
      super
      @consumable = nil
    end
  end
end