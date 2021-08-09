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
        item_key = ('a'.ord + index).chr
        console.print(
          x: @x + 1, y: @y + @h - 2 - index,
          string: "#{item_key}) #{item.name}"
        )
      end
    end

    def valid_input_char?(char)
      ('a'..'z').include? char
    end

    def item_for_char(char)
      index = char.ord - 'a'.ord
      @inventory.items[index]
    end
  end
end
