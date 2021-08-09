module Components
  class Consumable < BaseComponent
    def consume
      item_container = entity.parent
      item_container.remove_entity entity
    end
  end
end
