module Entity
  class Player < Actor
    def die
      super
      $game.input_event_handler = InputEventHandler::GameOver.new
    end

    protected

    def death_message
      'You died!'
    end

    def build_ai
      Components::AI::None
    end
  end
end
