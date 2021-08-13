module Scenes
  class PositionSelection < BaseScene
    def initialize(help_topic: nil, &build_action_for_selected)
      @build_action_for_selected = build_action_for_selected
      $game.cursor_position = ScreenLayout.map_to_console_position [$game.player.x, $game.player.y]
      @help_topic = help_topic || 'Target Selection'
      super()
    end

    def render(console)
      return unless valid_position? $game.cursor_position

      render_selection(console)
    end

    def valid_position?(position)
      map_position = ScreenLayout.console_to_map_position position
      $game.game_map.in_bounds?(map_position.x, map_position.y)
    end

    def action_for_position(position)
      build_action_for_selected(position).tap { |action|
        pop_scene if action&.respond_to? :perform
      }
    end

    protected

    def build_action_for_selected(selected)
      @build_action_for_selected.call(selected)
    end

    def render_selection(console)
      x, y = $game.cursor_position
      console.bg[x, y] = Colors.white
      console.fg[x, y] = Colors.black
    end

    def move_cursor_if_possible(dx, dy)
      new_position = [$game.cursor_position.x + dx, $game.cursor_position.y + dy]
      return unless valid_position? new_position

      $game.cursor_position = new_position
    end

    def dispatch_action_for_right
      move_cursor_if_possible(1, 0)
    end

    def dispatch_action_for_left
      move_cursor_if_possible(-1, 0)
    end

    def dispatch_action_for_up
      move_cursor_if_possible(0, 1)
    end

    def dispatch_action_for_down
      move_cursor_if_possible(0, -1)
    end

    def dispatch_action_for_confirm
      selected_position = ScreenLayout.console_to_map_position $game.cursor_position
      action_for_position selected_position
    end

    alias dispatch_action_for_click dispatch_action_for_confirm

    def dispatch_action_for_quit
      pop_scene
    end

    def dispatch_action_for_help
      $game.show_help(@help_topic)
    end
  end
end
