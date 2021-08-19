class GameMap < DataBackedObject
  attr_reader :entities

  data_reader :width, :height, :portal_location

  def initialize(data)
    super()
    @data = data

    data[:tiles] ||= Array.new(width * height) { :wall }
    data[:explored] ||= Array.new(width * height) { false }
    @tile_data = Array2D.new(width, height, data[:tiles])
    @visible = Array2D.new(width, height) { false }
    @explored = Array2D.new(width, height, data[:explored])
    @entities = []
    calculate_tiles
  end

  def calculate_tiles
    @tiles = Array2D.new(width, height, @tile_data.data.map { |type| Tiles.send(type) })
    @transparent_tiles = Array2D.new(width, height, @tiles.data.map(&:transparent?))
  end

  def id_as_parent
    { type: :game_map }
  end

  def game_map
    self
  end

  def add_entity(entity)
    entities << entity
  end

  def remove_entity(entity)
    entities.delete(entity)
  end

  def actors
    entities.select { |entity| entity.is_a?(Entity::Actor) && entity.alive? }
  end

  def items
    entities.select { |entity| entity.is_a?(Entity::Item) }
  end

  def entity_at?(x, y)
    entities.any? { |entity| entity.x == x && entity.y == y }
  end

  def entities_at(x, y)
    entities.select { |entity| entity.x == x && entity.y == y }
  end

  def items_at(x, y)
    items.select { |item| item.x == x && item.y == y }
  end

  def actor_at(x, y)
    actors.find { |entity| entity.x == x && entity.y == y }
  end

  def in_bounds?(x, y)
    x >= 0 && x < width && y >= 0 && y < height
  end

  def walkable?(x, y)
    @tiles[x, y]&.walkable?
  end

  def visible?(x, y)
    @visible[x, y]
  end

  def explored?(x, y)
    @explored[x, y]
  end

  def to_s
    "GameMap(#{width}, #{height})"
  end

  def positions_in_radius(center:, radius:, &condition)
    [].tap { |result|
      ((center.x - radius)..(center.x + radius)).each do |x|
        ((center.y - radius)..(center.y + radius)).each do |y|
          next if center == [x, y]
          next unless !condition || Engine::LineOfSight.bresenham(center, [x, y]).all?(&condition)

          result << [x, y]
        end
      end
    }
  end

  def render(console, offset_y: nil)
    console.assign_tiles(0, offset_y || 0, @rendered_tiles)

    RenderOrder.each do |render_order|
      entities.select { |entity| entity.render_order == render_order }.each do |entity|
        next unless visible?(entity.x, entity.y)

        console.print(x: entity.x, y: entity.y + offset_y, string: entity.char, fg: entity.color)
      end
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

  private

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
    shroud = Engine::Tile.new(' ', fg: [255, 255, 255], bg: nil)
    @rendered_tiles = Array2D.new(
      width,
      height,
      [].tap { |result|
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
      }
    )
  end
end
