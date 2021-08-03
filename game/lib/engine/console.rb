require 'lib/engine/console/buffer_cell.rb'

module Engine
  # Simulated terminal for rendering the tiles
  class Console
    attr_reader :width, :height

    def initialize(width, height)
      @width = width
      @height = height

      @buffer = Array2D.new(width, height) { |index| BufferCell.new(self, index) }
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

    def draw_frame(x:, y:, width:, height:, decoration: nil)
      decoration_chars = (decoration || '┌─┐│ │└─┘').unicode_chars

      right = x + width - 1
      top = y + height - 1
      (x..right).each do |current_x|
        (y..top).each do |current_y|
          char_index = if current_x == x
                         if current_y == y
                           6 # bottom left
                         elsif current_y < top
                           3 # left
                         else
                           0 # top left
                         end
                       elsif current_x < right
                         if current_y == y
                           7 # bottom
                         elsif current_y < top
                           4 # middle
                         else
                           1 # top
                         end
                       else
                         if current_y == y
                           8 # bottom right
                         elsif current_y < top
                           5 # right
                         else
                           2 # top right
                         end
                       end
          @buffer[current_x, current_y].char = decoration_chars[char_index]
        end
      end
    end

    def assign_tiles(x, y, tile_array_2d)
      assigned_index = 0
      assigned_data = tile_array_2d.data
      assigned_size = assigned_data.size
      assigned_w = tile_array_2d.w

      own_data = @buffer.data
      own_w = @width
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
