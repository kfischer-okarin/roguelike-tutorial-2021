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

      @buffer = Array2D.new(w, h) { |index| RenderedCell.new(self, index) }
      @prepared = false
    end

    def mouse_coordinates(gtk_inputs)
      mouse = gtk_inputs.mouse
      [mouse.x.idiv(@tileset.tile_w), mouse.y.idiv(@tileset.tile_h)]
    end

    def print(x:, y:, string:, fg: nil)
      string.each_char.with_index do |char, index|
        cell = @buffer[x + index, y]
        cell.char = char
        cell.color = fg
      end
    end

    def draw_rect(x:, y:, width:, height:, bg:)
      (y...(y + height)).each do |current_y|
        (x...(x + width)).each do |current_x|
          cell = @buffer[current_x, current_y]
          cell.char ||= ' '
          cell.background_color = bg
        end
      end
    end

    def assign_tiles(x, y, tile_array_2d)
      assigned_index = 0
      assigned_data = tile_array_2d.data
      assigned_size = assigned_data.size
      assigned_w = tile_array_2d.w

      own_data = @buffer.data
      own_w = @w
      own_index = y * own_w + x
      next_row_index = own_index + assigned_w

      while assigned_index < assigned_size
        cell = own_data[own_index]
        assigned_cell = assigned_data[assigned_index]
        cell.char = assigned_cell.char
        cell.color = assigned_cell.fg
        cell.background_color = assigned_cell.bg
        assigned_index += 1
        own_index += 1
        if own_index >= next_row_index
          own_index = own_index - assigned_w + own_w
          next_row_index += own_w
        end
      end
    end

    def clear
      fn.each_send @buffer.data, RenderedCell, :clear
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
      buffer = @buffer.data
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
