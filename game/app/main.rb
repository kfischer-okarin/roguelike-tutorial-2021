require 'lib/engine.rb'

def tick(args)
  setup(args) if args.tick_count.zero?

  $terminal.print(x: args.state.player_x, y: args.state.player_y, string: '@')
  $terminal.render(args)
  render_framerate(args)
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

$gtk.reset
