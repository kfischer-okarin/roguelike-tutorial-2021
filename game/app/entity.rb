require 'app/entity/base_entity.rb'
require 'app/entity/actor.rb'

module Entity
  def self.from(data)
    if data.respond_to? :combatant
      Actor.new(data.entity_id, data)
    else
      BaseEntity.new(data.entity_id, data)
    end
  end
end
