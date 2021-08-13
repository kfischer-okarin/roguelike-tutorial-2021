module Scenes
  class Help < BaseScene
    def initialize(topic:)
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
      @message_window.render(console)
    end

    def dispatch_action_for_quit
      $game.pop_scene
    end

    private

    HELP_TEXTS = {}

    def self.define_help_text(topic, text)
      HELP_TEXTS[topic] = text.freeze
    end

    define_help_text 'Gameplay',
<<-TEXT
Explore and survive. Move into enemies to attack them.

Arrow Keys - Movement
         i - Open inventory
         d - Drop item
         v - Show message log
         / - Look around (Keyboard)
. or Space - Wait


? - Show help of current screen
ESC - Return to previous screen
TEXT

    define_help_text 'Message Log',
<<-TEXT
     Up/Down - Scroll up/down one line
Page Up/Down - Scroll up/down ten lines
        Home - Scroll to top
         End - Scroll to bottom

         ESC - Return to game
TEXT

    define_help_text 'Item Selection',
<<-TEXT
Select the item you want to use by pressing a-z or by clicking on it.

ESC - Cancel selection and return to game
TEXT

    define_help_text 'Look',
<<-TEXT
Select a position with the arrow keys to display the names of the characters and items at that position.

You can do the same during normal gameplay by pointing the mouse at a map position.

ESC - Return to game
TEXT

    define_help_text 'Target Selection',
<<-TEXT
Select a position to target with the arrow keys or by pointing the mouse at it.

Enter or Mouse click - Select the position
ESC - Return to game
TEXT

    def help_text(topic)
      HELP_TEXTS[topic] || ''
    end
  end
end
