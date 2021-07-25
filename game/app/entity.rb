module Entity
  class << self
    def move(entity, dx:, dy:)
      entity.x += dx
      entity.y += dy
    end

    def build(type, x:, y:)
      attributes = { x: x, y: y }.merge!(@prototypes[type] || {})
      $state.new_entity_strict(type, attributes)
    end

    def define_prototype(type, char:, color:, name: nil, blocks_movement: false)
      @prototypes ||= {}
      @prototypes[type] = { char: char, color: color, name: name || '<Unnamed>', blocks_movement: blocks_movement }
    end
  end
end

Entity.define_prototype :player, name: 'Player', char: '@', color: [255, 255, 255], blocks_movement: true
Entity.define_prototype :mutant_spider, name: 'Mutant Spider', char: 's', color: [63, 127, 63], blocks_movement: true
Entity.define_prototype :cyborg_bearman, name: 'Cyborg Bearman', char: 'B', color: [0, 127, 0], blocks_movement: true
