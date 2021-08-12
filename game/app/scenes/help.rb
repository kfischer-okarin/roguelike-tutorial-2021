module Scenes
  class Help < BaseScene
    def initialize(previous_scene, topic:)
      @previous_scene = previous_scene
      super()
      @topic = topic
      @message_window = UI::MessageWindow.new(
        w: 40,
        h: 30,
        title: "Help: #{topic}",
        text: help_text(topic)
      )
    end

    def render(console)
      @previous_scene.render(console)
      @message_window.render(console)
    end

    protected

    def build_input_handler
      InputEventHandler.new
    end

    class InputEventHandler < BaseInputHandler
      def dispatch_action_for_quit
        $game.pop_scene
        nil
      end
    end

    private

    HELP_TEXTS = {}

    def self.define_help_text(topic, text)
      HELP_TEXTS[topic] = text.freeze
    end

    define_help_text 'Gameplay',
<<-TEXT
Arrow Keys - Movement
i - Open inventory
d - Drop item
v - Show message log
/ - Look around (Keyboard)
. or Space - Wait


? - Show help of current screen
ESC - Return to previous screen
TEXT

    def help_text(topic)
      HELP_TEXTS[topic] || ''
    end
  end
end
