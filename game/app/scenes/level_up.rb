module Scenes
  class LevelUp < BaseScene
    def initialize(window_x: 0)
      super
      @window_x = window_x
      @window_top = 44
      @window_w = 35
      @window_h = 8
      @choice = UI::Choice.new(
        choices: [
          "Constitution (+20 HP, from #{$game.player.combatant.max_hp})",
          "Strength (+1, from #{$game.player.combatant.power})",
          "Agility (+1, from #{$game.player.combatant.defense})"
        ],
        x: @window_x + 1, top: @window_top - 4, w: @window_w - 2
      )
    end

    def render(console)
      console.draw_frame(
        x: @window_x, y: @window_top - @window_h + 1, width: @window_w, height: @window_h,
        title: 'Level Up',
        fg: Colors.item_window_fg, bg: Colors.item_window_bg
      )
      console.print(x: @window_x + 1, y: @window_top - 1, string: 'Congratulations! You level up!')
      console.print(x: @window_x + 1, y: @window_top - 2, string: 'Select an attribute to increasse.')
      @choice.render(console)
    end

    def dispatch_action_for_char_typed(event)
      choice_index = @choice.choice_index_for_char_typed_event(event)
      case choice_index
      when 0..2
        execute_choice choice_index
      else
        return
      end

      pop_scene
    end

    def dispatch_action_for_click
      choice_index = @choice.mouse_over_index
      return unless choice_index

      execute_choice choice_index
      pop_scene
    end

    private

    def execute_choice(index)
      case index
      when 0
        $game.player.level.increase_max_hp
      when 1
        $game.player.level.increase_power
      when 2
        $game.player.level.increase_defense
      end
    end
  end
end
