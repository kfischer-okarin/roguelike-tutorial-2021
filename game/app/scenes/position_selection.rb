module Scenes
  class PositionSelection < BaseScene
    def initialize(gameplay_scene, &build_action_for_selected_position)
      @build_action_for_selected_position = build_action_for_selected_position
      @gameplay_scene = gameplay_scene
      $game.cursor_position = ScreenLayout.map_to_console_position [$game.player.x, $game.player.y]
      super()
    end

    def render(console)
      @gameplay_scene.render(console)
      x, y = $game.cursor_position
      console.bg[x, y] = Colors.white
      console.fg[x, y] = Colors.black
    end

    def action_for_position(position)
      @build_action_for_selected_position.call position
    end

    def after_action_performed
      $game.pop_scene
      @gameplay_scene.after_action_performed
    end

    protected

    def build_input_handler
      InputEventHandler.new(self)
    end

    class InputEventHandler < BaseInputHandler
      def initialize(selection_scene)
        super()
        @selection_scene = selection_scene
      end

      def dispatch_action_for_right
        $game.cursor_position.x += 1
        nil
      end

      def dispatch_action_for_left
        $game.cursor_position.x -= 1
        nil
      end

      def dispatch_action_for_up
        $game.cursor_position.y += 1
        nil
      end

      def dispatch_action_for_down
        $game.cursor_position.y -= 1
        nil
      end

      def dispatch_action_for_confirm
        selected_position = ScreenLayout.console_to_map_position $game.cursor_position
        @selection_scene.action_for_position selected_position
      end

      def dispatch_action_for_quit
        $game.pop_scene
        nil
      end
    end
  end
end
