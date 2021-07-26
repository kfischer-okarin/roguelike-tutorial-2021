module EntityPrototypes
  class << self
    def build(type, x:, y:)
      attributes = { x: x, y: y }.merge!(@prototypes[type] || {})
      entity_data = $state.new_entity_strict(type, attributes)
      EntityObj.from(entity_data)
    end

    def define(type, char:, color:, name: nil, blocks_movement: false)
      @prototypes ||= {}
      @prototypes[type] = { char: char, color: color, name: name || '<Unnamed>', blocks_movement: blocks_movement }
    end
  end
end

EntityPrototypes.define :player, name: 'Player', char: '@', color: [255, 255, 255], blocks_movement: true
EntityPrototypes.define :mutant_spider, name: 'Mutant Spider', char: 's', color: [63, 127, 63], blocks_movement: true
EntityPrototypes.define :cyborg_bearman, name: 'Cyborg Bearman', char: 'B', color: [0, 127, 0], blocks_movement: true
