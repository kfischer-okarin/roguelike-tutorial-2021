module Engine
  # Simulated terminal for rendering the tiles
  class Terminal
    def initialize(w, h, tileset:)
      @w = w
      @h = h
      @tileset = tileset

      @buffer = Array.new(w * h)
    end

    def print(x:, y:, string:)
      @buffer[y * @w + x] = string
    end

    def render(args)
      args.outputs.background_color = [0, 0, 0]
      args.outputs.primitives << self
    end

    def primitive_marker
      :sprite
    end

    def draw_override(ffi_draw)
      tileset = @tileset
      w = @w
      path = tileset.path
      tile_w = tileset.tile_w
      tile_h = tileset.tile_h
      index = 0
      buffer = @buffer
      buffer_size = buffer.size
      while index < buffer_size
        element = buffer[index]
        index += 1
        next unless element

        ffi_draw.draw_sprite_4 (index % w) * tile_w, index.idiv(w) * tile_h, tile_w, tile_h,
                               path,
                               nil, # angle
                               nil, nil, nil, nil, # a, r, g, b
                               nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                               nil, nil, # flip_horizontally, flip_vertically
                               nil, nil, # angle_anchor_x, angle_anchor_y
                               tileset.tile_x(buffer), tileset.tile_y(buffer), tile_w, tile_h,
                               1 # blendmode_enum
      end
    end
  end
end
