module Components
  class BaseComponent < DataBackedObject
    attr_reader :entity, :data

    def initialize(entity, data)
      super()
      @entity = entity
      @data = data
    end
  end
end
