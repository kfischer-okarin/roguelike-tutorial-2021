module Components
  class Equipment < BaseComponent
    attr_reader :weapon, :armor

    def power_bonus
      (weapon&.equippable&.power_bonus || 0) + (armor&.equippable&.power_bonus || 0)
    end

    def defense_bonus
      (weapon&.equippable&.defense_bonus || 0) + (armor&.equippable&.defense_bonus || 0)
    end

    def equip(item)
      set_slot(item.equippable.slot, item)
      item.equippable.equipped_by = entity
    end

    def set_slot(slot, item)
      instance_variable_set(:"@#{slot}", item)
    end
  end
end
