module Entities
  class << self
    include Enumerable

    attr_accessor :gtk_state

    def setup
      @gtk_state.entities = []
    end

    def add(entity)
      @gtk_state.entities << entity
    end

    def each(&block)
      @gtk_state.entities.each(&block)
    end

    def player
      @gtk_state.player
    end

    def player=(value)
      @gtk_state.player = value
    end
  end
end
