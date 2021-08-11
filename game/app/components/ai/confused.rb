module Components
  module AI
    class Confused < BaseComponent
      DIRECTIONS = [
        [0, 1],
        [1, 1],
        [1, 0],
        [1, -1],
        [0, -1],
        [-1, -1],
        [-1, 0],
        [-1, 1]
      ].map(&:freeze).freeze

      data_accessor :turns, :previous_ai

      def perform_action
        if turns.positive?
          dx, dy = $game.rng.random_element_from(DIRECTIONS)
          self.turns -= 1
          BumpIntoEntityAction.new(entity, dx: dx, dy: dy).perform
        else
          $message_log.add_message(text: "The #{entity.name} is no longer confused.")
          entity.replace_ai previous_ai
        end
      end
    end
  end
end
