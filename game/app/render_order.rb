module RenderOrder
  CORPSE = 1
  ACTOR = 2

  def self.each
    yield CORPSE
    yield ACTOR
  end
end
