class GameTile
  attr_reader :tile

  def initialize(walkable:, tile:)
    @walkable = walkable
    @tile = tile
  end

  def walkable?
    @walkable
  end
end
