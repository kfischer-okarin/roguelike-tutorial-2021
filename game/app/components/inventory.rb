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
      @items ||= []
    end

    def drop(item)
      entity.equipment.unequip item if item.equippable
      owning_entity = entity
      item.place owning_entity.game_map, x: owning_entity.x, y: owning_entity.y
      $message_log.add_message(text: "You dropped the #{item.name}")
    end
  end
end
