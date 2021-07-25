class GameMap
  attr_reader :width, :height, :entities

  def initialize(width:, height:, entities:)
    @width = width
    @height = height
    @entities = entities
    @tiles = Array2D.new(width, height) { Tiles.wall }

    @visible = Array2D.new(width, height) { false }
    @explored = Array2D.new(width, height) { false }

    update_transparent_tiles
  end

  def set_tile(x, y, tile)
    @tiles[x, y] = tile
    update_transparent_tiles
  end

  def fill_rect(rect, tile)
    @tiles.fill_rect(rect, tile)
    update_transparent_tiles
  end

  def in_bounds?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end

  def walkable?(x, y)
    @tiles[x, y]&.walkable?
  end

  def visible?(x, y)
    @visible[x, y]
  end

  def render(terminal, offset_y: nil)
    terminal.assign_tiles(0, offset_y || 0, @rendered_tiles)
    @entities.each do |entity|
      next unless visible?(entity.x, entity.y)

      terminal.print(x: entity.x, y: entity.y + offset_y, string: entity.char, fg: entity.color)
    end
  end

  def update_fov(x:, y: , radius:)
    @visible = Engine::FieldOfView.calculate_line_of_sight_4e(
      transparency_map: @transparent_tiles,
      x: x,
      y: y,
      radius: radius
    )
    update_explored_tiles
    update_rendered_tiles
  end

  def entity_at?(x, y)
    @entities.any? { |entity| entity.x == x && entity.y == y }
  end

  def blocking_entity_at(x, y)
    @entities.find { |entity| entity.blocks_movement && entity.x == x && entity.y == y }
  end

  def add_entity(entity)
    entity.game_map = self
    @entities.add entity
  end

  private

  def update_transparent_tiles
    @transparent_tiles = Array2D.new(@width, @height, @tiles.data.map(&:transparent?))
  end

  def update_explored_tiles
    visible = @visible.data
    explored = @explored.data
    visible_size = visible.size
    index = 0
    while index < visible_size
      explored[index] ||= visible[index]
      index += 1
    end
  end

  def update_rendered_tiles
    shroud = Engine::Terminal::Tile.new(' ', fg: [255, 255, 255], bg: nil)
    @rendered_tiles = Array2D.new(@width, @height, [].tap { |result|
      tiles = @tiles.data
      visible = @visible.data
      explored = @explored.data
      index = 0
      size = tiles.size
      while index < size
        tile = tiles[index]
        result << if visible[index]
                    tile.light
                  elsif explored[index]
                    tile.dark
                  else
                    shroud
                  end
        index += 1
      end
    })
  end
end
