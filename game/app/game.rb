class Game
  attr_reader :player
  attr_accessor :cursor_position, :scene

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

  def show_inventory
    @scene = Scenes::ItemSelection.new(
      @scene,
      inventory: player.inventory,
      title: 'Select an item to use',
      window_x: item_window_x
    ) do |selected_item|
      UseItemAction.new(@player, selected_item)
    end
  end

  def show_drop_item_menu
    @scene = Scenes::ItemSelection.new(
      @scene,
      inventory: player.inventory,
      title: 'Select an item to drop',
      window_x: item_window_x
    ) do |selected_item|
      DropItemAction.new(@player, selected_item)
    end
  end

  def quit
    $gtk.request_quit
  end

  private

  def item_window_x
    @player.x <= 30 ? 40 : 0
  end
end
