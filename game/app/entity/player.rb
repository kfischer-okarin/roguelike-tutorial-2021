module Entity
  class Player < Actor
    def die
      super
      $game.input_event_handler = InputEventHandler::GameOver.new
    end

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

    def build_ai
      Components::AI::None
    end
  end
end
