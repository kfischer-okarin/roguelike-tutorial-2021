module Entities
  class << self
    include Enumerable

    attr_accessor :gtk_state

    def setup
      @gtk_state.entities_by_id = {}
    end

    def add(entity)
      @gtk_state.entities_by_id[entity.entity_id] = entity
    end

    def each(&block)
      @gtk_state.entities_by_id.each_value(&block)
    end

    def player
      @gtk_state.player
    end

    def player=(value)
      @gtk_state.player = value
    end
  end
end
