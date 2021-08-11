module Entity
  class Player < Actor
    def attack_message_color
      Colors.player_attack
    end

    protected

    def death_message
      'You died!'
    end

    def death_message_color
      Colors.player_death
    end
  end
end
