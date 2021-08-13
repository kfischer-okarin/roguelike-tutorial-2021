module Scenes
  class MainMenu < BaseScene
    def render(console)
      console.background_image = 'title.png'
      render_title(console)
      render_menu(console)
    end

    def dispatch_action_for_main_menu_new_game
      new_game
    end

    def dispatch_action_for_main_menu_quit_game
      $game.quit
    end

    private

    def render_title(console)
      console.print_centered(
        x: console.width.idiv(2), y: console.height.idiv(2) + 4,
        string: 'OUTLANDISH AND HAZARDOUS',
        fg: Colors.menu_title
      )
      console.print_centered(
        x: console.width.idiv(2), y: 2,
        string: 'By Kevin Fischer',
        fg: Colors.menu_title
      )
    end

    def render_menu(console)
      [
        '[N] Play a new game',
        '[C] Continue last game',
        '[Q] Quit'
      ].each_with_index do |text, index|
        x = console.width.idiv(2) - 12
        y = console.height.idiv(2) - 2 - index
        console.draw_rect(x: x, y: y, width: 24, height: 1, bg: [0, 0, 0, 150])
        console.print(x: x, y: y, string: text, fg: Colors.menu_text)
      end
    end
  end
end
