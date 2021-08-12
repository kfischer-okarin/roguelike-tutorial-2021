require 'lib/array_2d.rb'
require 'lib/data_backed_object.rb'
require 'lib/priority_queue.rb'
require 'lib/engine.rb'

require 'app/rng.rb'
require 'app/colors.rb'
require 'app/render_order.rb'
require 'app/actions.rb'
require 'app/components.rb'
require 'app/entity.rb'
require 'app/entity_prototypes.rb'
require 'app/entities.rb'
require 'app/message_log.rb'
require 'app/scenes.rb'
require 'app/game.rb'
require 'app/ui.rb'
require 'app/game_tile.rb'
require 'app/tiles.rb'
require 'app/procgen.rb'
require 'app/game_map.rb'
require 'app/screen_layout.rb'

def tick(args)
  setup(args) if args.tick_count.zero?

  Entities.gtk_state = args.state
  $render_context.gtk_outputs = args.outputs

  begin
    $game.cursor_position = $render_context.mouse_coordinates(args.inputs) if args.inputs.mouse.moved
    $game.render($console)
    $game.handle_input_events(process_input(args.inputs))
    $render_context.present($console)
  rescue StandardError => e
    message = e.inspect
    log_error(message)
    $message_log.add_message(text: message, fg: Colors.error)
  end

  render_framerate(args)
end

def setup(args)
  # DragonRuby is fixed at 1280x720 so choosing a resolution that fits neatly
  screen_width = 80  # 80 * 16 = 1280
  screen_height = 45 # 45 * 16 = 720

  tileset = Engine::Tileset.new('Zilk-16x16.png')
  $render_context = Engine::RenderContext.new(screen_width, screen_height, tileset: tileset)
  $console = Engine::Console.new(screen_width, screen_height)

  Entities.setup(args.state)
  Entities.player = EntityPrototypes.build(:player)

  $message_log = MessageLog.new
  $message_log.add_message(text: 'Hello and welcome, traveler, to yet another dimension!', fg: Colors.welcome_text)

  map_width = 80
  map_height = 40

  procgen_parameters = Procgen::DungeonGenerator::Parameters.new(
    max_rooms: 10,
    room_size_range: (6..10),
    max_monsters_per_room: 2,
    max_items_per_room: 2
  )

  game_map = Procgen.generate_dungeon(
    map_width: map_width,
    map_height: map_height,
    parameters: procgen_parameters,
    player: Entities.player
  )

  $game = Game.new(player: Entities.player)
  $game.game_map = game_map
  $game.scene = Scenes::Gameplay.new(player: Entities.player)
end

def render_framerate(args)
  args.outputs.primitives << [0, 720, $gtk.current_framerate.to_i.to_s, 255, 255, 255].label
end

def process_input(gtk_inputs)
  key_down = gtk_inputs.keyboard.key_down
  [].tap { |result|
    result << { type: :quit } if key_down.escape
    result << { type: :up } if key_down.up || key_down.k
    result << { type: :down } if key_down.down || key_down.j
    result << { type: :left } if key_down.left || key_down.h
    result << { type: :right } if key_down.right || key_down.l
    result << { type: :up_right } if key_down.u
    result << { type: :up_left } if key_down.y
    result << { type: :down_right } if key_down.n
    result << { type: :down_left } if key_down.b
    result << { type: :wait } if key_down.space || key_down.period
    result << { type: :view_history } if key_down.v
    result << { type: :page_up } if key_down.pageup
    result << { type: :page_down } if key_down.pagedown
    result << { type: :home } if key_down.home
    result << { type: :end } if key_down.end
    result << { type: :get } if key_down.g
    result << { type: :inventory } if key_down.i
    result << { type: :drop } if key_down.d
    result << { type: :confirm } if key_down.enter
    result << { type: :look } if key_down.forward_slash
    result << { type: :char_typed, char: gtk_inputs.text[0] } unless gtk_inputs.text.empty?
  }
end

$gtk.reset
