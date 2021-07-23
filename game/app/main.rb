require 'lib/engine.rb'

require 'app/input_event_handler.rb'
require 'app/entity.rb'
require 'app/game.rb'
require 'app/game_tile.rb'
require 'app/tiles.rb'
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

  map_width = 80
  map_height = 40

  Entities.gtk_state = args.state
  args.state.player = Entities.build(x: screen_width.idiv(2), y: screen_height.idiv(2), char: '@', color: [255, 255, 255])
  npc = Entities.build(x: screen_width.idiv(2) - 5, y: screen_height.idiv(2), char: '@', color: [255, 255, 0])
  args.state.entities = [args.state.player, npc]

  game_map = GameMap.new(width: map_width, height: map_height)

  tileset = Engine::Tileset.new('Zilk-16x16.png')
  $terminal = Engine::Terminal.new(screen_width, screen_height, tileset: tileset)

  $game = Game.new(entities: Entities, input_event_handler: InputEventHandler, game_map: game_map, player: nil)
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

module Entities
  class << self
    attr_accessor :gtk_state

    def build(x:, y:, char:, color:)
      @gtk_state.new_entity_strict(:entity, x: x, y: y, char: char, color: color)
    end

    def each(&block)
      @gtk_state.entities.each(&block)
    end

    def player
      @gtk_state.player
    end
  end
end

$gtk.reset
