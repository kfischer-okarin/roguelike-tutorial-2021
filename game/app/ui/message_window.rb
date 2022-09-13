module UI
  class MessageWindow
    def initialize(title:, text:, w:, h:)
      @w = w
      @h = h
      @x = ($render_console.width - w).idiv(2)
      @y = ($render_console.height - h).idiv(2)
      @title = title
      @lines = text.split("\n").flat_map { |line|
        line.empty? ? [''] : line.wrapped_lines(w - 2).map { |l| l.gsub("\n", '') }
      }
    end

    def render(console)
      console.draw_frame(x: @x, y: @y, width: @w, height: @h, fg: Colors.white, bg: Colors.black, title: @title)

      x = @x + 1
      y = @y + @h - 2
      bottom = @y + 1
      line_index = 0

      loop do
        break if y < bottom || line_index >= @lines.size

        line = @lines[line_index]

        console.print(x: x, y: y, string: line)
        y -= 1
        line_index += 1
      end
    end
  end
end
