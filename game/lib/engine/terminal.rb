require 'lib/engine/terminal/tile.rb'

module Engine
  # Simulated terminal for rendering the tiles
  class Terminal
    attr_accessor :gtk_outputs

    attr_reader :w, :h, :tileset

    def initialize(w, h, tileset:)
      @w = w
      @h = h
      @tileset = tileset

      @buffer = Array.new(w * h) { |index| RenderedCell.new(self, index) }
      @prepared = false
    end

    def print(x:, y:, string:, fg: nil)
      cell = @buffer[y * @w + x]
      cell.char = string
      cell.color = fg
    end

    def cell_tiles
      CellTilesAccessor.new(@buffer, w: @w)
    end

    class CellTilesAccessor
      attr_reader :array, :w

      def initialize(array, w:)
        @w = w
        @array = array
      end

      def []=(x_range, y, value)
        x = x_range.begin
        w = x_range.end - x_range.begin + (x_range.exclude_end? ? 0 : 1)
        block_assignment = BlockAssignment.new(self, x: x, y: y, w: w)
        fn.each_with_index_send(value, block_assignment, :assign)
      end

      class BlockAssignment
        def initialize(accessor, x:, y:, w:)
          @accessor = accessor
          @x = x
          @y = y
          @w = w
          @target_start_index = y * accessor.w + x
        end

        def assign(value, index)
          target_x = index % @w
          target_y = index.idiv(@w)
          target_index = @target_start_index + target_y * @w + target_x
          cell = @accessor.array[target_index]
          cell.char = value.char
          cell.color = value.fg
          cell.background_color = value.bg
        end
      end
    end

    def set_cell_tile(cell_tile, index)
      cell = @buffer[index]
      cell.char = cell_tile.char
      cell.color = cell_tile.fg
      cell.background_color = cell_tile.bg
    end

    def clear
      fn.each_send @buffer, RenderedCell, :clear
    end

    def render
      prepare unless @prepared
      @gtk_outputs.background_color = [0, 0, 0]
      @gtk_outputs.primitives << self
    end

    def primitive_marker
      :sprite
    end

    class RenderedCell
      attr_reader :x, :y, :r, :g, :b, :bg_r, :bg_g, :bg_b
      attr_accessor :char

      def initialize(terminal, index)
        @x = (index % terminal.w) * terminal.tileset.tile_w
        @y = index.idiv(terminal.w) * terminal.tileset.tile_h
      end

      def color=(color)
        @r, @g, @b = color || [nil, nil, nil]
      end

      def background_color=(color)
        if color
          @bg_r, @bg_g, @bg_b = color
          @bg_color = true
        else
          @bg_r = @bg_g = @bg_b = nil
          @bg_color = false
        end
      end

      def bg_color?
        @bg_color
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

        if cell.bg_color?
          ffi_draw.draw_sprite_4 cell.x, cell.y, tile_w, tile_h,
                                 'bg',
                                 nil, # angle
                                 nil, cell.bg_r, cell.bg_g, cell.bg_b, # a, r, g, b
                                 nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                                 nil, nil, # flip_horizontally, flip_vertically
                                 nil, nil, # angle_anchor_x, angle_anchor_y
                                 nil, nil, nil, nil, # source_x, source_y, source_w, source_h
                                 1 # blendmode_enum
        end
        next if cell.char == ' '

        ffi_draw.draw_sprite_4 cell.x, cell.y, tile_w, tile_h,
                               path,
                               nil, # angle
                               nil, cell.r, cell.g, cell.b, # a, r, g, b
                               nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                               nil, nil, # flip_horizontally, flip_vertically
                               nil, nil, # angle_anchor_x, angle_anchor_y
                               tileset.tile_x(char), tileset.tile_y(char), tile_w, tile_h,
                               1 # blendmode_enum
      end
    end

    private

    def prepare
      prepare_bg_sprite
      @prepared = true
    end

    def prepare_bg_sprite
      render_target = @gtk_outputs[:bg]
      render_target.width = @tileset.tile_w
      render_target.height = @tileset.tile_h
      render_target.primitives << [0, 0, @tileset.tile_w, @tileset.tile_h, 255, 255, 255].solid
    end
  end
end
