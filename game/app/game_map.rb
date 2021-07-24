class GameMap
  attr_reader :width, :height

  def initialize(width:, height:)
    @width = width
    @height = height
    @tiles = Array2D.new(width, height) { Tiles.wall }

    @visible = Array2D.new(width, height) { false }
    @explored = Array2D.new(width, height) { false }

    calc_rendered_tiles
  end

  def set_tile(x, y, tile)
    @tiles[x, y] = tile
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
    @rendered_tiles = Array2D.new(@width, @height, @tiles.data.map(&:dark))
  end
end
