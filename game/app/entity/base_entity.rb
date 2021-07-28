module Entity
  class BaseEntity < DataBackedObject
    attr_reader :id

    attr_accessor :game_map

    def initialize(id, data)
      super()
      @id = id
      @data = data
    end

    def place(game_map, x:, y:)
      @game_map = game_map
      game_map.add_entity self
      self.x = x
      self.y = y
    end

    data_accessor :x, :y, :char, :color, :render_order, :name
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
end
