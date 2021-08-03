require 'lib/engine/console/buffer_cell.rb'

module Engine
  # Simulated terminal for rendering the tiles
  class Console
    attr_reader :w, :h

    def initialize(w, h)
      @w = w
      @h = h

      @buffer = Array2D.new(w, h) { |index| BufferCell.new(self, index) }
    end

    def buffer_data
      @buffer.data
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
      fn.each_send @buffer.data, BufferCell, :clear
    end
  end
end
