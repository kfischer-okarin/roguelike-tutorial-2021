module EntityPrototypes
  class << self
    def build(type)
      prototype = copy_prototype @prototypes.fetch(type)
      Entity.build(type, build_initial_attributes(prototype))
    end

    def define(type, data)
      @prototypes ||= {}
      @prototypes[type] = data
    end

    def define_actor(type, data)
      define(
        type,
        {
          blocks_movement: true,
          render_order: RenderOrder::ACTOR,
          inventory: { items: [] }
        }.merge(data)
      )
    end

    def define_item(type, data)
      define(type, { blocks_movement: false, render_order: RenderOrder::ITEM }.merge(data))
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

EntityPrototypes.define_item  :bandages,
                              name: 'Bandages',
                              char: '!', color: [127, 0, 255],
                              consumable: { type: :healing, amount: 4 }
