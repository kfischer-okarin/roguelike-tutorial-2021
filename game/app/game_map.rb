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

  def walkable?(x, y)
    cell_at(x, y)&.walkable?
  end

  def render(terminal, offset_y: nil)
    terminal.cell_tiles[0...@width, offset_y || 0] = @tiles.map(&:tile)
  end

  private

  def cell_at(x, y)
    @tiles[y * @width + x]
  end
end
