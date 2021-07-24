module Procgen
  class RectangularRoom
    def initialize(x:, y:, width:, height:)
      @x = x
      @y = y
      @w = width
      @h = height
    end

    def inner_rect
      [@x + 1, @y + 1, @w - 2, @h - 2]
    end

    def center
      [@x + @w.idiv(2), @y + @h.idiv(2)]
    end
  end
end
