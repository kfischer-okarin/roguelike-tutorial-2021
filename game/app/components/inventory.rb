module Components
  class Inventory < BaseComponent
    def id_as_parent
      { type: :inventory, entity_id: entity.id }
    end

    def add_entity(entity)
      items << entity
    end

    def remove_entity(entity)
      items.delete entity
    end

    def items
      Entities.children_of(self)
    end

    def drop(item)
      owning_entity = entity
      item.place owning_entity.game_map, x: owning_entity.x, y: owning_entity.y
      $message_log.add_message(text: "You dropped the #{item.name}")
    end
  end
end
