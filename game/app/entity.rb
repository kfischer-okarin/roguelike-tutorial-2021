module Entity
  class << self
    def move(entity, dx:, dy:)
      entity.x += dx
      entity.y += dy
    end

    def build(type, x:, y:)
      attributes = { x: x, y: y }.merge!(@prototypes[type] || {})
      entity_data = $state.new_entity_strict(type, attributes)
      EntityObj.from(entity_data)
    end

    def define_prototype(type, char:, color:, name: nil, blocks_movement: false)
      @prototypes ||= {}
      @prototypes[type] = { char: char, color: color, name: name || '<Unnamed>', blocks_movement: blocks_movement }
    end
  end
end

class DataBackedObject
  def self.data_reader(*attributes)
    attributes.each do |attribute|
      define_method attribute do
        data.send(attribute)
      end
    end
  end

  def self.data_writer(*attributes)
    attributes.each do |attribute|
      method = :"#{attribute}="
      define_method method do |value|
        data.send(method, value)
      end
    end
  end

  def self.data_accessor(*attributes)
    data_reader(*attributes)
    data_writer(*attributes)
  end

  def initialize(data)
    @data = data
  end
end

class EntityObj < DataBackedObject
  attr_reader :id

  attr_accessor :game_map

  def initialize(id, data)
    super(data)
    @id = id
  end

  def self.from(data)
    new(data.entity_id, data)
  end

  data_accessor :x, :y, :char, :color, :name
  data_writer :blocks_movement

  def blocks_movement?
    data.blocks_movement
  end

  def data
    @data ||= Entities.data_for(@id)
  end

  def reset_reference
    @data = nil
  end

  def move(dx, dy)
    self.x += dx
    self.y += dy
  end
end

Entity.define_prototype :player, name: 'Player', char: '@', color: [255, 255, 255], blocks_movement: true
Entity.define_prototype :mutant_spider, name: 'Mutant Spider', char: 's', color: [63, 127, 63], blocks_movement: true
Entity.define_prototype :cyborg_bearman, name: 'Cyborg Bearman', char: 'B', color: [0, 127, 0], blocks_movement: true
