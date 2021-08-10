require 'app/scenes/gameplay/input_event_handler.rb'

module Scenes
  class Gameplay < BaseScene
    attr_reader :game_map

    def initialize(game_map:, player:)
      @player = player
      super()
      @game_map = game_map
      @hp_bar = UI::Bar.new(
        name: 'HP',
        maximum_value: @player.combatant.max_hp,
        total_width: 20,
        fg: Colors.hp_bar_filled,
        bg: Colors.hp_bar_empty
      )
      @message_log = UI::MessageLog.new(x: 21, y: 0, width: 40, height: 5)
      update_fov
    end

    def render(console)
      render_game_map(console)
      render_hp_bar(console)
      render_message_log(console)
      render_names_at_cursor_position(console)
    end

    def after_action_performed
      handle_enemy_turns
      update_fov
      handle_game_over unless @player.alive?
    end

    protected

    def build_input_handler
      InputEventHandler.new(player: @player)
    end

    private

    def handle_enemy_turns
      @game_map.actors.each do |entity|
        entity.ai.perform_action
      rescue Action::Impossible
        # no op
      end
    end

    def update_fov
      @game_map.update_fov(x: @player.x, y: @player.y, radius: 8)
    end

    def handle_game_over
      $game.scene = GameOver.new(self)
    end

    def render_game_map(console)
      @game_map.render(console, offset_y: ScreenLayout.map_offset.y)
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
      return unless @game_map.in_bounds?(cursor_x, cursor_y) && @game_map.visible?(cursor_x, cursor_y)

      names_at_cursor_position = @game_map.entities_at(cursor_x, cursor_y).map(&:name).join(', ').capitalize
      console.print(x: 21, y: 5, string: names_at_cursor_position)
    end
  end
end
