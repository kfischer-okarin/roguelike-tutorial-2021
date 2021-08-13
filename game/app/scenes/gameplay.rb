module Scenes
  class Gameplay < BaseScene
    def initialize(player:)
      @player = player
      super()
      @hp_bar = UI::Bar.new(
        name: 'HP',
        maximum_value: @player.combatant.max_hp,
        total_width: 20,
        fg: Colors.hp_bar_filled,
        bg: Colors.hp_bar_empty
      )
      @message_log = UI::MessageLog.new(x: 21, y: 0, width: 40, height: 5)
    end

    def render(console)
      render_game_map(console)
      render_hp_bar(console)
      render_message_log(console)
      render_names_at_cursor_position(console)
    end

    def dispatch_action_for_quit
      EscapeAction
    end

    def dispatch_action_for_up
      BumpIntoEntityAction.new(player, dx: 0, dy: 1)
    end

    def dispatch_action_for_down
      BumpIntoEntityAction.new(player, dx: 0, dy: -1)
    end

    def dispatch_action_for_left
      BumpIntoEntityAction.new(player, dx: -1, dy: 0)
    end

    def dispatch_action_for_right
      BumpIntoEntityAction.new(player, dx: 1, dy: 0)
    end

    def dispatch_action_for_up_right
      BumpIntoEntityAction.new(player, dx: 1, dy: 1)
    end

    def dispatch_action_for_up_left
      BumpIntoEntityAction.new(player, dx: -1, dy: 1)
    end

    def dispatch_action_for_down_right
      BumpIntoEntityAction.new(player, dx: 1, dy: -1)
    end

    def dispatch_action_for_down_left
      BumpIntoEntityAction.new(player, dx: -1, dy: -1)
    end

    def dispatch_action_for_get
      PickupAction.new(player)
    end

    def dispatch_action_for_wait
      WaitAction
    end

    def dispatch_action_for_view_history
      push_scene Scenes::HistoryViewer.new
    end

    def dispatch_action_for_inventory
      $game.show_inventory('Select an item to use') do |selected_item|
        selected_item.consumable.get_action(player)
      end
    end

    def dispatch_action_for_drop
      $game.show_inventory('Select an item to drop') do |selected_item|
        DropItemAction.new(player, selected_item)
      end
    end

    def dispatch_action_for_look
      $game.select_position(help_topic: 'Look') do
        # no op - don't perform action on enter
      end
    end

    def dispatch_action_for_help
      $game.show_help('Gameplay')
    end

    private

    attr_reader :player

    def game_map
      $game.game_map
    end

    def render_game_map(console)
      game_map.render(console, offset_y: ScreenLayout.map_offset.y)
    end

    def render_hp_bar(console)
      @hp_bar.current_value = @player.combatant.hp
      @hp_bar.maximum_value = @player.combatant.max_hp
      @hp_bar.render(console, x: 1, y: 4)
    end

    def render_message_log(console)
      @message_log.messages = $message_log.messages
      @message_log.render(console)
    end

    def render_names_at_cursor_position(console)
      cursor_x, cursor_y = ScreenLayout.console_to_map_position $game.cursor_position
      return unless game_map.in_bounds?(cursor_x, cursor_y) && game_map.visible?(cursor_x, cursor_y)

      names_at_cursor_position = game_map.entities_at(cursor_x, cursor_y).map(&:name).join(', ').capitalize
      console.print(x: 21, y: 5, string: names_at_cursor_position)
    end
  end
end
