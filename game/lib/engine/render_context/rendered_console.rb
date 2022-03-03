module Engine
  class RenderContext
    # Primitive that does the actual rendering
    class RenderedConsole
      attr_accessor :console

      def initialize(tileset)
        @tileset = tileset
      end

      def primitive_marker
        :sprite
      end

      def draw_override(ffi_draw)
        tileset = @tileset
        path = tileset.path
        tile_w = tileset.tile_w
        tile_h = tileset.tile_h
        tiles_per_row = tileset.tiles_per_row
        index = 0
        buffer = @console.buffer_data
        buffer_size = buffer.size
        space_index = tileset.tile_index(' ')
        while index < buffer_size
          x, y, char, r, g, b, a, bg_r, bg_g, bg_b, bg_a, bg_color = buffer[index]
          index += 1
          next unless char

          x *= tile_w
          y *= tile_h
          char_index = tileset.tile_index(char)

          if bg_color
            ffi_draw.draw_sprite_4 x, y, tile_w, tile_h,
                                   'bg',
                                   nil, # angle
                                   bg_a, bg_r, bg_g, bg_b, # a, r, g, b
                                   nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                                   nil, nil, # flip_horizontally, flip_vertically
                                   nil, nil, # angle_anchor_x, angle_anchor_y
                                   nil, nil, nil, nil, # source_x, source_y, source_w, source_h
                                   1 # blendmode_enum
          end
          next if char_index == space_index

          tile_x = (char_index % tiles_per_row) * tile_w
          tile_y = char_index.idiv(tiles_per_row) * tile_h

          ffi_draw.draw_sprite_4 x, y, tile_w, tile_h,
                                 path,
                                 nil, # angle
                                 a, r, g, b, # a, r, g, b
                                 nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                                 nil, nil, # flip_horizontally, flip_vertically
                                 nil, nil, # angle_anchor_x, angle_anchor_y
                                 tile_x, tile_y, tile_w, tile_h,
                                 1 # blendmode_enum
        end
      end
    end
  end
end
