class Game
  attr_reader :player, :game_map

  def initialize(input_event_handler:, player:)
    @input_event_handler = input_event_handler
    @player = player
  end

  def game_map=(value)
    @game_map = value
    update_fov
  end

  def handle_input_events(input_events)
    input_events.each do |event|
      action = @input_event_handler.dispatch_action_for(event)
      next unless action

      action.perform
      handle_enemy_turns
      update_fov
    end
  end

  def render(terminal)
    terminal.clear
    @game_map.render(terminal, offset_y: 5)
    terminal.render
  end

  def quit
    $gtk.request_quit
  end

  private

  def handle_enemy_turns
    @game_map.actors.each do |entity|
      entity.ai.perform_action
    end
  end

  def update_fov
    @game_map.update_fov(x: @player.x, y: @player.y, radius: 8)
  end
end
