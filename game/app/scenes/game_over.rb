module Scenes
  class GameOver < BaseScene
    attr_reader :input_event_handler

    protected

    def build_input_handler
      InputEventHandler.new
    end

    class InputEventHandler < BaseInputHandler
      def dispatch_action_for_quit
        EscapeAction
      end
    end
  end
end
