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

class Entity < DataBackedObject
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

