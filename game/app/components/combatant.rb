module Components
  class Combatant < BaseComponent
    data_reader :max_hp, :hp, :power, :defense

    def hp=(value)
      data.hp = value.clamp(0, data.max_hp)
    end
  end
end
