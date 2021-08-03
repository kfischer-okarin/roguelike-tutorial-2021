class Game
  attr_reader :player
  attr_accessor :mouse_position, :scene

  def initialize(player:, scene:)
    @player = player
    @scene = scene
  end

  def handle_input_events(input_events)
    @scene.handle_input_events(input_events)
  end

  def render(terminal)
    terminal.clear
    @scene.render(terminal)
  end

  def quit
    $gtk.request_quit
  end
end
