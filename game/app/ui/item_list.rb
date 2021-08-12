module UI
  class ItemList
    def initialize(inventory, x:, top:, title:)
      @inventory = inventory
      @title = title
      @x = x
      @h = [@inventory.items.size + 2, 3].max
      @y = top - @h + 1
      @w = @title.size + 4
    end

    def render(console)
      console.draw_frame(
        x: @x, y: @y, width: @w, height: @h,
        title: @title,
        fg: Colors.item_window_fg, bg: Colors.item_window_bg
      )

      @inventory.items.each_with_index do |item, index|
        y = item_y(index)
        item_key = ('a'.ord + index).chr
        console.print(
          x: @x + 1, y: y,
          string: "#{item_key}) #{item.name}"
        )
        next unless mouse_on_item_at_index? index

        console.draw_rect(
          x: @x + 1, y: y, width: @w - 2, height: 1,
          bg: Colors.item_window_selected
        )
      end
    end

    def item_y(index)
      @y + @h - 2 - index
    end

    def mouse_over_item
      mouse_over_index = (0...@inventory.items.size).find { |index| mouse_on_item_at_index? index }
      return unless mouse_over_index

      @inventory.items[mouse_over_index]
    end

    def valid_input_char?(char)
      ('a'..'z').include? char
    end

    def item_for_char(char)
      index = char.ord - 'a'.ord
      @inventory.items[index]
    end

    def mouse_on_item_at_index?(index)
      cursor_x, cursor_y = $game.cursor_position
      (cursor_y == item_y(index) && cursor_x >= (@x + 1) && cursor_x < (@x + @w - 2))
    end
  end
end
