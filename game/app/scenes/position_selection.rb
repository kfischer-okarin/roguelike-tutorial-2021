module Scenes
  class PositionSelection < BaseScene
    def initialize(gameplay_scene, &build_action_for_selected)
      @build_action_for_selected = build_action_for_selected
      @gameplay_scene = gameplay_scene
      $game.cursor_position = ScreenLayout.map_to_console_position [$game.player.x, $game.player.y]
      super()
    end

    def render(console)
      @gameplay_scene.render(console)
      return unless valid_position? $game.cursor_position

      render_selection(console)
    end

    def valid_position?(position)
      map_position = ScreenLayout.console_to_map_position position
      $game.game_map.in_bounds?(map_position.x, map_position.y)
    end

    def action_for_position(position)
      build_action_for_selected(position)
    end

    def after_action_performed
      $game.pop_scene
      @gameplay_scene.after_action_performed
    end

    protected

    def build_input_handler
      InputEventHandler.new(self)
    end

    def build_action_for_selected(selected)
      @build_action_for_selected.call(selected)
    end

    def render_selection(console)
      x, y = $game.cursor_position
      console.bg[x, y] = Colors.white
      console.fg[x, y] = Colors.black
    end

    class InputEventHandler < BaseInputHandler
      def initialize(selection_scene)
        super()
        @selection_scene = selection_scene
      end

      def move_cursor_if_possible(dx, dy)
        new_position = [$game.cursor_position.x + dx, $game.cursor_position.y + dy]
        return unless @selection_scene.valid_position? new_position

        $game.cursor_position = new_position
      end

      def dispatch_action_for_right
        move_cursor_if_possible(1, 0)
        nil
      end

      def dispatch_action_for_left
        move_cursor_if_possible(-1, 0)
        nil
      end

      def dispatch_action_for_up
        move_cursor_if_possible(0, 1)
        nil
      end

      def dispatch_action_for_down
        move_cursor_if_possible(0, -1)
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
