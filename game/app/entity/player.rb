module Entity
  class Player < Actor
    protected

    def build_ai
      Components::AI::None
    end
  end
end
