module Components
  class Combatant < BaseComponent
    data_reader :max_hp, :hp, :power, :defense

    def hp=(value)
      data.hp = value.clamp(0, data.max_hp)
      entity.die if dead?
    end

    def heal(amount)
      return 0 if hp == max_hp

      old_hp = hp
      self.hp += amount

      hp - old_hp
    end

    def take_damage(amount)
      self.hp -= amount
    end

    def dead?
      hp.zero?
    end
  end
end
