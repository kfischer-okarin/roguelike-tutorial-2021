module Components
  class Inventory < BaseComponent
    def id_as_parent
      { type: :inventory, entity_id: entity.id }
    end

    def add_entity(entity)
      data.items << entity.id
    end

    def remove_entity(entity)
      data.items.delete entity.id
    end

    def items
      data.items.map { |entity_id| Entities.get(entity_id) }
    end

    def drop(item)
      owning_entity = entity
      item.place owning_entity.game_map, x: owning_entity.x, y: owning_entity.y
      $message_log.add_message(text: "You dropped the #{item.name}")
    end
  end
end
