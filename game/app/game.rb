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

  def render(console)
    console.clear
    @scene.render(console)
  end

  def show_history(console)
    @scene = Scenes::HistoryViewer.new(previous_scene: @scene, console: console)
  end

  def quit
    $gtk.request_quit
  end
end
