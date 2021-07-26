module EntityPrototypes
  class << self
    def build(type)
      prototype = copy_prototype @prototypes.fetch(type)
      entity_data = $state.new_entity_strict(type, build_initial_attributes(prototype))
      Entity.from(entity_data)
    end

    def define(type, data)
      @prototypes ||= {}
      @prototypes[type] = data
    end

    def define_actor(type, data)
      define(type, { blocks_movement: true }.merge(data))
    end

    private

    def copy_prototype(prototype)
      $gtk.deserialize_state $gtk.serialize_state(prototype)
    end

    def build_initial_attributes(prototype)
      { x: nil, y: nil }.tap { |result|
        result.update(prototype)
        result[:combatant][:max_hp] = result[:combatant][:hp] if result.key? :combatant
      }
    end
  end
end

EntityPrototypes.define_actor :player,
                              name: 'Player',
                              char: '@', color: [255, 255, 255],
                              combatant: { hp: 30, defense: 2, power: 5 }

EntityPrototypes.define_actor :mutant_spider,
                              name: 'Mutant Spider',
                              char: 's', color: [63, 127, 63],
                              combatant: { hp: 10, defense: 0, power: 3 }

EntityPrototypes.define_actor :cyborg_bearman,
                              name: 'Cyborg Bearman',
                              char: 'B', color: [0, 127, 0],
                              combatant: { hp: 16, defense: 1, power: 4 }
