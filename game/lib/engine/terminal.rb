module Engine
  # Simulated terminal for rendering the tiles
  class Terminal
    attr_reader :w, :h, :tileset

    def initialize(w, h, tileset:)
      @w = w
      @h = h
      @tileset = tileset

      @buffer = Array.new(w * h) { |index| RenderedCell.new(self, index) }
    end

    def print(x:, y:, string:)
      @buffer[y * @w + x].char = string
    end

    def clear
      fn.each_send @buffer, RenderedCell, :clear
    end

    def render(args)
      args.outputs.background_color = [0, 0, 0]
      args.outputs.primitives << self
    end

    def primitive_marker
      :sprite
    end

    class RenderedCell
      attr_reader :x, :y
      attr_accessor :char

      def initialize(terminal, index)
        @x = (index % terminal.w) * terminal.tileset.tile_w
        @y = index.idiv(terminal.w) * terminal.tileset.tile_h
      end

      def self.clear(cell)
        cell.char = nil
      end
    end

    def draw_override(ffi_draw)
      tileset = @tileset
      path = tileset.path
      tile_w = tileset.tile_w
      tile_h = tileset.tile_h
      index = 0
      buffer = @buffer
      buffer_size = buffer.size
      while index < buffer_size
        cell = buffer[index]
        char = cell.char
        index += 1
        next unless char

        ffi_draw.draw_sprite_4 cell.x, cell.y, tile_w, tile_h,
                               path,
                               nil, # angle
                               nil, nil, nil, nil, # a, r, g, b
                               nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                               nil, nil, # flip_horizontally, flip_vertically
                               nil, nil, # angle_anchor_x, angle_anchor_y
                               tileset.tile_x(char), tileset.tile_y(char), tile_w, tile_h,
                               1 # blendmode_enum
      end
    end
  end
end
