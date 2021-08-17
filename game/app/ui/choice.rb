module UI
  class Choice
    def initialize(choices:, x:, top:, w:)
      @choices = choices
      @x = x
      @top = top
      @w = w
    end

    def render(console)
      @choices.each_with_index do |choice, index|
        y = choice_y(index)
        choice_key = ('a'.ord + index).chr
        console.print(x: @x, y: y, string: "#{choice_key}) #{choice}")
        next unless mouse_on_choice_at_index? index

        console.draw_rect(
          x: @x, y: y, width: @w, height: 1,
          bg: Colors.item_window_selected
        )
      end
    end

    def choice_index_for_char_typed_event(event)
      return unless valid_input_char? event[:char]

      event.char.ord - 'a'.ord
    end

    def choice_y(index)
      @top - index
    end

    def mouse_over_index
      (0...@choices.size).find { |index| mouse_on_choice_at_index? index }
    end

    def valid_input_char?(char)
      ('a'..'z').include? char
    end

    def mouse_on_choice_at_index?(index)
      cursor_x, cursor_y = $game.cursor_position
      (cursor_y == choice_y(index) && cursor_x >= @x && cursor_x < (@x + @w))
    end
  end
end
