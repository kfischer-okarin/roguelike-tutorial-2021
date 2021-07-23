require 'lib/engine.rb'

require 'app/input_event_handler.rb'

def tick(args)
  setup(args) if args.tick_count.zero?

  $terminal.print(x: args.state.player_x, y: args.state.player_y, string: '@')
  $terminal.render(args)
  render_framerate(args)

  handle_input(args)
end

def setup(args)
  # DragonRuby is fixed at 1280x720 so choosing a resolution that fits neatly
  screen_width = 80  # 80 * 16 = 1280
  screen_height = 45 # 45 * 16 = 720

  args.state.player_x = screen_width.idiv(2)
  args.state.player_y = screen_height.idiv(2)

  tileset = Engine::Tileset.new('Zilk-16x16.png')
  $terminal = Engine::Terminal.new(screen_width, screen_height, tileset: tileset)
end

def render_framerate(args)
  args.outputs.primitives << [0, 720, $gtk.current_framerate.to_i.to_s, 255, 255, 255].label
end

def handle_input(args)
  events = process_input(args.inputs)
  events.each do |event|
    action = InputEventHandler.dispatch_action_for(event)
    next unless action

    action.execute(args)
  end
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
