require 'app/entity/base_entity.rb'
require 'app/entity/actor.rb'
require 'app/entity/player.rb'
require 'app/entity/item.rb'

module Entity
  class << self
    def from(data)
      return Player.new(data.entity_id, data) if data.entity_type == :player

      if data.respond_to? :combatant
        Actor.new(data.entity_id, data)
      elsif data.respond_to? :consumable
        Item.new(data.entity_id, data)
      else
        BaseEntity.new(data.entity_id, data)
      end
    end

    def build(type, attributes)
      data = $state.new_entity_strict(type, attributes)
      from(data)
    end
  end
end
