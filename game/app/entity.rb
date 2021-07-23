module Entity
  class << self
    def move(entity, dx:, dy:)
      entity.x += dx
      entity.y += dy
    end
  end
end
