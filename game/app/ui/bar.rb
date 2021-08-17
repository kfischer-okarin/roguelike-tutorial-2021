module UI
  class Bar
    attr_accessor :current_value, :maximum_value

    def initialize(name:, maximum_value:, total_width:, fg:, bg:)
      @name = name
      @current_value = maximum_value
      @maximum_value = maximum_value
      @total_width = total_width
      @fg = fg
      @bg = bg
    end

    def render(console, x:, y:)
      bar_width = [((@current_value / @maximum_value) * @total_width).to_i, @total_width].min
      console.draw_rect(x: x, y: y, width: @total_width, height: 1, bg: @bg)
      console.draw_rect(x: x, y: y, width: bar_width, height: 1, bg: @fg)
      console.print(
        x: x + 1, y: y,
        string: "#{@name}: #{@current_value}/#{@maximum_value}",
        fg: Colors.bar_text
      )
    end
  end
end
