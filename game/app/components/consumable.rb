module Components
  class Consumable < BaseComponent
    class << self
      def from(entity, data)
        case data.type
        when :healing
          Healing.new(entity, data)
        when :lightning_damage
          LightningDamage.new(entity, data)
        when :confusion
          Confusion.new(entity, data)
        when :explosion
          Explosion.new(entity, data)
        end
      end
    end

    def get_action(consumer)
      UseItemAction.new(consumer, entity)
    end

    def consume
      item_container = entity.parent
      item_container.remove_entity entity
      Entities.delete entity
    end
  end
end
