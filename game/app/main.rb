require 'lib/engine.rb'

def tick(args)
  setup(args) if args.tick_count.zero?

  $terminal.print(x: 1, y: 1, string: '@')
  $terminal.render(args)
  render_framerate(args)
end

def setup(_args)
  # DragonRuby is fixed at 1280x720 so choosing a resolution that fits neatly
  screen_width = 80  # 80 * 16 = 1280
  screen_height = 45 # 45 * 16 = 720

  tileset = Engine::Tileset.new('Zilk-16x16.png')
  $terminal = Engine::Terminal.new(screen_width, screen_height, tileset: tileset)
end

def render_framerate(args)
  args.outputs.primitives << [0, 720, $gtk.current_framerate.to_i.to_s, 255, 255, 255].label
end

$gtk.reset
