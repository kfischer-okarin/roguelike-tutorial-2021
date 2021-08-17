module Scenes
  class CharacterScreen < BaseScene
    def initialize(window_x: 0)
      super
      @window_x = window_x
      @window_top = 44
      @title = 'Character Information'
      @window_w = @title.size + 4
      @window_h = 7
    end

    def render(console)
      console.draw_frame(
        x: @window_x, y: @window_top - @window_h + 1, width: @window_w, height: @window_h,
        title: @title,
        fg: Colors.item_window_fg, bg: Colors.item_window_bg
      )
      player = $game.player
      level = player.level
      console.print(x: @window_x + 1, y: @window_top - 1, string: "Level: #{level.current_level}")
      console.print(x: @window_x + 1, y: @window_top - 2, string: "XP: #{level.current_xp}")
      console.print(x: @window_x + 1, y: @window_top - 3, string: "XP for next Level: #{level.experience_to_next_level}")
      combatant = player.combatant
      console.print(x: @window_x + 1, y: @window_top - 4, string: "Attack: #{combatant.power}")
      console.print(x: @window_x + 1, y: @window_top - 5, string: "Defense: #{combatant.defense}")
    end

    def dispatch_action_for_quit
      pop_scene
    end

    alias dispatch_action_for_character_screen dispatch_action_for_quit

    def dispatch_action_for_help
      $game.show_help('Character Screen')
    end
  end
end
