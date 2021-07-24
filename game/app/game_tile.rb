class GameTile
  attr_reader :light, :dark

  def initialize(walkable:, transparent:, light:, dark:)
    @walkable = walkable
    @transparent = transparent
    @light = light
    @dark = dark
  end

  def walkable?
    @walkable
  end

  def transparent?
    @transparent
  end
end
