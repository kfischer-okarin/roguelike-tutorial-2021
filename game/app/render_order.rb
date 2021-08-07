module RenderOrder
  CORPSE = 1
  ITEM = 2
  ACTOR = 3

  def self.each
    yield CORPSE
    yield ITEM
    yield ACTOR
  end
end
