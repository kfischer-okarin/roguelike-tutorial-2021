module Procgen
  class RectangularRoom
    attr_reader :x, :y, :w, :h, :top, :right

    def initialize(x, y, w, h)
      @x = x
      @y = y
      @w = w
      @h = h
      @top = y + h - 1
      @right = x + w - 1
    end

    def inner_rect
      [@x + 1, @y + 1, @w - 2, @h - 2]
    end

    def center
      [@x + @w.idiv(2), @y + @h.idiv(2)]
    end

    def intersects?(other)
      @x <= other.right && @right >= other.x && @y <= other.top && @top >= other.y
    end
  end
end
