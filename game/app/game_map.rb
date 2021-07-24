class GameMap
  def initialize(width:, height:)
    @width = width
    @height = height
    @tiles = Array2D.new(
      Array.new(width * height) { Tiles.wall },
      w: width,
      h: height
    )

    calc_rendered_tiles
  end

  def fill_rect(rect, tile)
    @tiles.fill_rect(rect, tile)
    calc_rendered_tiles
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

  private

  def calc_rendered_tiles
    @rendered_tiles = Array2D.new(
      @tiles.data.map(&:tile),
      w: @width,
      h: @height
    )
  end
end
