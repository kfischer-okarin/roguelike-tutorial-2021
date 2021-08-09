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

    def print(x:, y:, string:, fg: nil, bg: nil)
      string.unicode_chars.each_with_index do |char, index|
        cell = @buffer[x + index, y]
        cell.char = char
        cell.color = fg if fg
        cell.background_color = bg if bg
      end
    end

    def print_centered(x:, y:, string:, fg: nil, bg: nil)
      actual_x = x - string.length.idiv(2)
      print(x: actual_x, y: y, string: string, fg: fg, bg: bg)
    end

    # TODO: Word Wrap
    def print_box_centered(x:, y:, width:, height:, string:, fg: nil, bg: nil)
      box_center_x = x + width.idiv(2)
      top_y = y + height - 1
      print_centered(x: box_center_x, y: top_y, string: string, fg: fg, bg: bg)
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

    def draw_frame(x:, y:, width:, height:, decoration: nil, title: nil, fg: nil, bg: nil)
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
          cell = @buffer[current_x, current_y]
          cell.char = decoration_chars[char_index]
          cell.color = fg if fg
          cell.background_color = bg if bg
        end
      end

      print_centered(x: x + width.idiv(2), y: top, string: title, fg: bg, bg: fg) if title
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

    def blit(other_console, x:, y:)
      target_data = other_console.buffer_data
      target_w = other_console.width

      index = 0
      data = buffer_data
      data_size = data.size
      w = @width

      target_index = y * target_w + x
      next_row_index = target_index + w

      while index < data_size
        target_data[target_index][2..-1] = data[index][2..-1]
        target_index += 1
        index += 1
        if target_index >= next_row_index
          target_index = target_index - w + target_w
          next_row_index += target_w
        end
      end
    end

    def clear
      fn.each_send @buffer.data, BufferCell, :clear
    end
  end
end
