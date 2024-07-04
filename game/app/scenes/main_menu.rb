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

    def dispatch_action_for_main_menu_continue_game
      SaveGame.load if SaveGame.exists?
    end

    def dispatch_action_for_main_menu_quit_game
      return if $gtk.platform? :web

      $game.quit
    end

    private

    def new_game
      $state.entities = Entities.build_data
      Entities.data = $state.entities
      Entities.player = EntityPrototypes.build :player
      kitchen_knife = EntityPrototypes.build :kitchen_knife
      kitchen_knife.place Entities.player.inventory
      Entities.player.equipment.set_slot :weapon, kitchen_knife
      leather_jacket = EntityPrototypes.build :leather_jacket
      leather_jacket.place Entities.player.inventory
      Entities.player.equipment.set_slot :armor, leather_jacket

      $state.message_log = []
      $message_log = MessageLog.new $state.message_log
      $message_log.add_message(
        text: 'Hello and welcome, traveler, to yet another dimension! Press ? at any time for help.',
        fg: Colors.welcome_text
      )

      $state.game_world = {}
      $game.game_world = GameWorld.new($state.game_world)

      $game.player = Entities.player
      $game.generate_next_floor
      $game.scene = Scenes::Gameplay.new(player: Entities.player)
    end

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
      render_menu_entry(console, 0, '[N] Play a new game')
      render_menu_entry(console, 1, '[C] Continue last game') if SaveGame.exists?
      render_menu_entry(console, 2, '[Q] Quit') unless $gtk.platform? :web
    end

    def render_menu_entry(console, index, text)
      x = console.width.idiv(2) - 12
      y = console.height.idiv(2) - 2 - index
      console.draw_rect(x: x, y: y, width: 24, height: 1, bg: [0, 0, 0, 150])
      console.print(x: x, y: y, string: text, fg: Colors.menu_text)
    end
  end
end
