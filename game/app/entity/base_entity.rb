module Entity
  class BaseEntity < DataBackedObject
    attr_reader :id

    def initialize(id, data)
      super()
      @id = id
      @data = data
    end

    def place(parent, x: nil, y: nil)
      @parent.remove_entity self if @parent
      @parent = parent
      parent.add_entity self
      data.parent = parent.id_as_parent
      self.x = x
      self.y = y
    end

    def parent
      @parent ||= parent_from(data.parent)
    end

    def entity
      self
    end

    def game_map
      @parent.game_map
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

    def child_entities
      []
    end

    private

    def parent_from(parent_data)
      case parent_data[:type]
      when :inventory
        Entities.get(parent_data[:entity_id]).inventory
      end
    end
  end
end
