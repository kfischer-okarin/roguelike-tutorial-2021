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
      equipped_item = get_slot(item.equippable.slot)
      unequip equipped_item if equipped_item

      set_slot(item.equippable.slot, item)
      $message_log.add_message(text: "You equip the #{item.name}.")
    end

    def unequip(item)
      set_slot(item.equippable.slot, nil)
      $message_log.add_message(text: "You remove the #{item.name}.")
    end

    def set_slot(slot, item)
      previous_item = get_slot(slot)
      previous_item.equippable.equipped_by = nil if previous_item

      instance_variable_set(:"@#{slot}", item)
      item.equippable.equipped_by = entity if item
    end

    def get_slot(slot)
      instance_variable_get(:"@#{slot}")
    end
  end
end
