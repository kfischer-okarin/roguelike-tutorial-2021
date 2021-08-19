module Components
  class Equippable < BaseComponent
    data_reader :slot

    def equipped_by
      Entities.get(data.equipped_by)
    end

    def equipped_by=(entity)
      data.equipped_by = entity.id
    end

    def power_bonus
      data.power_bonus || 0
    end

    def defense_bonus
      data.defense_bonus || 0
    end
  end
end
