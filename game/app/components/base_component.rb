module Components
  class BaseComponent < DataBackedObject
    attr_reader :data

    def initialize(parent, data)
      super()
      @parent = parent
      @data = data
    end

    def game_map
      entity.game_map
    end

    def entity
      @parent.entity
    end
  end
end
