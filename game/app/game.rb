class Game
  attr_reader :player
  attr_accessor :input_event_handler, :game_map

  def initialize(player:)
    @player = player
  end

  def handle_input_events(input_events)
    @input_event_handler.handle_input_events(input_events)
  end

  def render(terminal)
    terminal.clear
    @game_map.render(terminal, offset_y: 5)
    terminal.print(x: 1, y: 2, string: "HP: #{@player.combatant.hp}/#{@player.combatant.max_hp}")
    terminal.render
  end

  def quit
    $gtk.request_quit
  end
end
