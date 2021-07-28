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
  end

  def handle_input_events(input_events)
    @input_event_handler.handle_input_events(input_events)
  end

  def render(terminal)
    terminal.clear
    @game_map.render(terminal, offset_y: 5)
    render_hp_bar(terminal)
    terminal.render
  end

  def quit
    $gtk.request_quit
  end

  private

  def render_hp_bar(terminal)
    @hp_bar.current_value = @player.combatant.hp
    @hp_bar.maximum_value = @player.combatant.max_hp
    @hp_bar.render(terminal, x: 1, y: 2)
  end
end
