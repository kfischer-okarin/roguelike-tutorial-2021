module Components
  class Combatant < DataBackedObject
    attr_reader :data

    data_reader :max_hp, :hp, :power, :defense

    def initialize(data)
      super()
      @data = data
    end

    def hp=(value)
      data.hp = value.clamp(0, data.max_hp)
    end
  end
end
