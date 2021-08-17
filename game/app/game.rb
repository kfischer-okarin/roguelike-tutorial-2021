class Game
  attr_reader :rng, :game_map, :scene
  attr_accessor :cursor_position, :player, :game_world

  def initialize
    @player = player
    @scene_stack = []
    @cursor_position = [0, 0]
    @rng = RNG.new
  end

  def generate_next_floor
    game_world.generate_next_floor
  end

  def game_map=(value)
    @game_map = value
    update_fov
  end

  def scene=(value)
    @scene = value
    @scene_stack = []
  end

  def handle_input_events(input_events)
    input_events.each do |event|
      action = @scene.handle_input_event(event)
      next unless handle_action(action)

      advance_turn
    end
  end

  def handle_action(action)
    return false unless action.respond_to? :perform

    action.perform
    true
  rescue Action::Impossible => e
    $message_log.add_message(text: e.message, fg: Colors.action_impossible)
    false
  end

  def advance_turn
    handle_enemy_turns
    update_fov
    handle_game_over unless @player.alive?
    handle_level_up if @player.level.requires_level_up?
  end

  def push_scene(next_scene)
    @scene_stack.push @scene
    @scene = next_scene
  end

  def pop_scene
    @scene = @scene_stack.pop
  end

  def replace_scene(new_scene)
    @scene = new_scene
  end

  def render(console)
    console.clear
    @scene_stack.each do |scene|
      scene.render(console)
    end
    @scene.render(console)
  end

  def show_inventory(title, &build_action_for_item)
    push_scene Scenes::ItemSelection.new(
      inventory: player.inventory,
      title: title,
      window_x: ui_window_x,
      &build_action_for_item
    )
  end

  def show_help(topic)
    push_scene Scenes::Help.new(topic: topic)
  end

  def quit
    $gtk.request_quit
  end

  private

  def handle_enemy_turns
    game_map.actors.each do |entity|
      entity.ai.perform_action
    rescue Action::Impossible
      # no op
    end
  end

  def update_fov
    game_map.update_fov(x: player.x, y: player.y, radius: 8)
  end

  def handle_game_over
    SaveGame.delete
    push_scene Scenes::GameOver.new
  end

  def handle_level_up
    push_scene Scenes::LevelUp.new(window_x: ui_window_x)
  end

  def ui_window_x
    @player.x <= 30 ? 40 : 0
  end
end
