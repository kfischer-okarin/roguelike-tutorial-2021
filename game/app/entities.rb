module Entities
  class << self
    include Enumerable

    def gtk_state=(value)
      @entity_objects.each(&:reset_reference) if @gtk_state && @gtk_state.object_id != value.object_id
      @gtk_state = value
      @entities_by_id = @gtk_state.entities_by_id
    end

    def setup(gtk_state)
      @gtk_state = nil
      gtk_state.entities_by_id = {}
      self.gtk_state = gtk_state
      @entity_objects_by_id = {}
      @children = {}
    end

    def <<(entity)
      @gtk_state.entities_by_id[entity.id] = entity.data
      @entity_objects_by_id[entity.id] = entity
    end

    def delete(entity)
      @gtk_state.entities_by_id.delete entity.id
      @entity_objects_by_id.delete entity.id
    end

    def children_of(parent)
      @children[parent] ||= []
    end

    def get(id)
      @entity_objects_by_id[id]
    end

    def each(&block)
      @entity_objects_by_id.each_value(&block)
    end

    def data_for(entity_id)
      @entities_by_id[entity_id]
    end

    def player
      @entity_objects_by_id[@gtk_state.player_id]
    end

    def player=(entity)
      self << entity
      @gtk_state.player_id = entity.data.entity_id
    end
  end
end
