module Scenes
  class GameOver < BaseScene
    attr_reader :input_event_handler

    def initialize(gameplay_scene)
      super()
      @gameplay_scene = gameplay_scene
    end

    def render(console)
      @gameplay_scene.render(console)
    end

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
