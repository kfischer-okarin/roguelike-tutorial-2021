module Entity
  class Player < Actor
    protected

    def death_message
      'You died!'
    end

    def build_ai
      Components::AI::None
    end
  end
end
