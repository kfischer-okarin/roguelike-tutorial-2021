module Entities
  class << self
    include Enumerable

    def build_data
      {
        entities_by_id: {},
        player_id: nil
      }
    end

    def data=(value)
      @data = value
      @entity_objects_by_id = {}
      @data.entities_by_id.each_value do |entity_data|
        @entity_objects_by_id[entity_data.entity_id] = Entity.from(entity_data)
      end
    end

    def <<(entity)
      @data.entities_by_id[entity.id] = entity.data
      @entity_objects_by_id[entity.id] = entity
    end

    def delete(entity)
      delete_children_of entity

      @data.entities_by_id.delete entity.id
      @entity_objects_by_id.delete entity.id
    end

    def get(id)
      @entity_objects_by_id[id]
    end

    def each(&block)
      @entity_objects_by_id.each_value(&block)
    end

    def data_for(entity_id)
      @data.entities_by_id[entity_id]
    end

    def player
      @entity_objects_by_id[@data.player_id]
    end

    def player=(entity)
      self << entity
      @data.player_id = entity.data.entity_id
    end

    private

    def delete_children_of(entity)
      entity.child_entities.each do |child_entity|
        delete child_entity
      end
    end
  end
end
