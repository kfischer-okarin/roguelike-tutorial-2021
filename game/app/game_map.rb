class GameMap
  def initialize(width:, height:)
    @width = width
    @height = height
    @tiles = Array2D.new(
      Array.new(width * height) { Tiles.floor },
      w: width,
      h: height
    )
    @tiles[30, 22] = Tiles.wall
    @tiles[31, 22] = Tiles.wall
    @tiles[32, 22] = Tiles.wall
    @tiles[33, 22] = Tiles.wall

    @rendered_tiles = Array2D.new(
      @tiles.data.map(&:tile),
      w: width,
      h: height
    )
  end

  def in_bounds?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end

  def walkable?(x, y)
    @tiles[x, y]&.walkable?
  end

  def render(terminal, offset_y: nil)
    terminal.assign_tiles(0, offset_y || 0, @rendered_tiles)
  end
end
