module Components
  class Equippable < BaseComponent
    data_reader :slot

    def power_bonus
      data.power_bonus || 0
    end

    def defense_bonus
      data.defense_bonus || 0
    end
  end
end
