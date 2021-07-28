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

    def render(terminal, x:, y:)
      bar_width = ((@current_value / @maximum_value) * @total_width).to_i
      terminal.draw_rect(x: x, y: y, width: @total_width, height: 1, bg: @bg)
      terminal.draw_rect(x: x, y: y, width: bar_width, height: 1, bg: @fg)
      terminal.print(x: x + 1, y: y, string: "#{@name}: #{@current_value}/#{@maximum_value}")
    end
  end
end
