class Game
  attr_reader :player
  attr_accessor :input_event_handler, :game_map

  def initialize(player:)
    @player = player
    @hp_bar = UI::Bar.new(
      name: 'HP',
      maximum_value: @player.combatant.max_hp,
      total_width: 20,
      fg: Colors.hp_bar_filled,
      bg: Colors.hp_bar_empty
    )
    @message_log = UI::MessageLog.new
  end

  def handle_input_events(input_events)
    @input_event_handler.handle_input_events(input_events)
  end

  def add_message(text:, fg:, stack: true)
    @message_log.add_message(text: text, fg: fg, stack: stack)
  end

  def render(terminal)
    terminal.clear
    render_game_map(terminal)
    render_hp_bar(terminal)
    render_message_log(terminal)
    terminal.render
  end

  def quit
    $gtk.request_quit
  end

  private

  def render_game_map(terminal)
    @game_map.render(terminal, offset_y: 5)
  end

  def render_hp_bar(terminal)
    @hp_bar.current_value = @player.combatant.hp
    @hp_bar.maximum_value = @player.combatant.max_hp
    @hp_bar.render(terminal, x: 1, y: 2)
  end

  def render_message_log(terminal)
    @message_log.render(terminal, x: 21, y: 0, width: 40, height: 5)
  end
end
