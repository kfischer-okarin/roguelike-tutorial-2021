module Components
  class Inventory < BaseComponent
    def add_entity(entity)
      data.items << entity.id
    end

    def items
      data.items.map { |entity_id| Entities.get(entity_id) }
    end
  end
end
