module Entity
  class Item < BaseEntity
    def consumable
      @consumable ||= Components::Consumable.from(self, data.consumable) if data.respond_to? :consumable
    end

    def equippable
      @equippable ||= Components::Equippable.new(self, data.equippable) if data.respond_to? :equippable
    end

    def activate(user)
      target_component.activate(user)
    end

    def get_action(user)
      target_component.get_action(user)
    end

    def reset_reference
      super
      @consumable = nil
      @equippable = nil
    end

    private

    def target_component
      consumable || equippable
    end
  end
end
