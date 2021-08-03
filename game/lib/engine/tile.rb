module Engine
  # Renderable tile
  class Tile
    attr_reader :char, :fg, :bg

    def initialize(char, fg:, bg:)
      @char = char
      @fg = fg
      @bg = bg
    end

    def to_s
      "Tile(#{@char.inspect}, #{@fg}, #{@bg})"
    end
  end
end
