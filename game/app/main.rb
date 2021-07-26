require 'lib/array_2d.rb'
require 'lib/engine.rb'

require 'app/input_event_handler.rb'
require 'app/entity.rb'
require 'app/entities.rb'
require 'app/game.rb'
require 'app/game_tile.rb'
require 'app/tiles.rb'
require 'app/procgen.rb'
require 'app/game_map.rb'

def tick(args)
  setup(args) if args.tick_count.zero?

  Entities.gtk_state = args.state
  $terminal.gtk_outputs = args.outputs

  $game.render($terminal)
  $game.handle_input_events(process_input(args.inputs))

  render_framerate(args)
end

def setup(args)
  # DragonRuby is fixed at 1280x720 so choosing a resolution that fits neatly
  screen_width = 80  # 80 * 16 = 1280
  screen_height = 45 # 45 * 16 = 720

  tileset = Engine::Tileset.new('Zilk-16x16.png')
  $terminal = Engine::Terminal.new(screen_width, screen_height, tileset: tileset)

  Entities.setup(args.state)
  Entities.player = Entity.build(:player, x: screen_width.idiv(2), y: screen_height.idiv(2))

  $game = Game.new(input_event_handler: InputEventHandler, player: Entities.player)

  map_width = 80
  map_height = 40

  procgen_parameters = Procgen::DungeonGenerator::Parameters.new(
    max_rooms: 10,
    room_size_range: (6..10),
    max_monsters_per_room: 2
  )

  $game.game_map = Procgen.generate_dungeon(
    map_width: map_width,
    map_height: map_height,
    parameters: procgen_parameters,
    player: Entities.player
  )
end

def render_framerate(args)
  args.outputs.primitives << [0, 720, $gtk.current_framerate.to_i.to_s, 255, 255, 255].label
end

def process_input(gtk_inputs)
  key_down = gtk_inputs.keyboard.key_down
  [].tap { |result|
    result << { type: :quit } if key_down.escape
    result << { type: :up } if key_down.up
    result << { type: :down } if key_down.down
    result << { type: :left } if key_down.left
    result << { type: :right } if key_down.right
  }
end

$gtk.reset
