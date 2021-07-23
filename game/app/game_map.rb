class GameMap
  def initialize(width:, height:)
    @width = width
    @height = height
    @tiles = Array.new(width * height) { Tiles.floor }
    @tiles[22 * width + 30] = Tiles.wall
    @tiles[22 * width + 31] = Tiles.wall
    @tiles[22 * width + 32] = Tiles.wall
    @tiles[22 * width + 33] = Tiles.wall
  end

  def in_bounds?(x, y)
    x.positive? && x < @width && y.positive? && y < @height
  end

  def render(terminal)
    terminal.cell_tiles[0...@width, 5] = @tiles
  end
end
