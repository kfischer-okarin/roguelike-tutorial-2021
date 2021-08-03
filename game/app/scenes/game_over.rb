module Scenes
  class GameOver < BaseScene
    attr_reader :input_event_handler

    def initialize(gameplay_scene)
      super()
      @gameplay_scene = gameplay_scene
      @input_event_handler = InputEventHandler.new
    end

    def render(terminal)
      @gameplay_scene.render(terminal)
    end

    class InputEventHandler < BaseInputHandler
      def dispatch_action_for_quit
        EscapeAction
      end
    end
  end
end