require 'tests/test_helper.rb'

def test_melee_action_deal_damage(_args, assert)
  TestHelper.init_globals
  attacker = TestHelper.build_combatant('Attacker', hp: 30, defense: 2, power: 5)
  defender = TestHelper.build_combatant('Defender', hp: 30, defense: 1, power: 3)
  TestHelper.build_map_with_entities(
    [3, 3] => attacker,
    [3, 4] => defender
  )

  MeleeAction.new(attacker, dx: 0, dy: 1).perform

  assert.includes! TestHelper.log_messages, 'Attacker attacks Defender for 4 hit points.'
  assert.equal! defender.combatant.hp, 26
end

def test_melee_action_deal_no_damage(_args, assert)
  TestHelper.init_globals
  attacker = TestHelper.build_combatant('Attacker', hp: 30, defense: 2, power: 1)
  defender = TestHelper.build_combatant('Defender', hp: 30, defense: 5, power: 3)
  TestHelper.build_map_with_entities(
    [3, 3] => attacker,
    [3, 4] => defender
  )

  MeleeAction.new(attacker, dx: 0, dy: 1).perform

  assert.includes! TestHelper.log_messages, 'Attacker attacks Defender but does no damage.'
  assert.equal! defender.combatant.hp, 30
end

def test_melee_action_nothing_to_attack(_args, assert)
  TestHelper.init_globals
  attacker = TestHelper.build_combatant('Attacker', hp: 30, defense: 2, power: 1)
  TestHelper.build_map_with_entities(
    [3, 3] => attacker
  )

  assert.raises_with_message!(Action::Impossible, 'Nothing to attack.') do
    MeleeAction.new(attacker, dx: 0, dy: -1).perform
  end
end

def test_move_action_success(_args, assert)
  TestHelper.init_globals
  entity = TestHelper.build_entity
  TestHelper.build_map_with_entities(
    [3, 3] => entity
  )

  MovementAction.new(entity, dx: 0, dy: -1).perform

  assert.equal! entity.x, 3
  assert.equal! entity.y, 2
end

def test_move_action_cannot_move_into_wall(_args, assert)
  TestHelper.init_globals
  entity = TestHelper.build_entity
  game_map = TestHelper.build_map_with_entities(
    [3, 3] => entity
  )
  game_map.set_tile(4, 3, Tiles.wall)

  assert.raises_with_message!(Action::Impossible, 'That way is blocked.') do
    MovementAction.new(entity, dx: 1, dy: 0).perform
  end
  assert.equal! entity.x, 3
  assert.equal! entity.y, 3
end

def test_move_action_cannot_move_beyond_map_bounds(_args, assert)
  TestHelper.init_globals
  entity = TestHelper.build_entity
  game_map = TestHelper.build_map(4, 4)
  entity.place(game_map, x: 3, y: 3)

  assert.raises_with_message!(Action::Impossible, 'That way is blocked.') do
    MovementAction.new(entity, dx: 1, dy: 0).perform
  end
  assert.equal! entity.x, 3
  assert.equal! entity.y, 3
end

module TestHelper
  class << self
    def build_map(width, height)
      GameMap.new(width: width, height: height, entities: []).tap { |game_map|
        game_map.fill_rect([0, 0, width, height], Tiles.floor)
      }
    end

    def build_map_with_entities(entities_by_position)
      width = entities_by_position.keys.map(&:x).max + 3
      height = entities_by_position.keys.map(&:y).max + 3
      build_map(width, height).tap { |game_map|
        entities_by_position.each do |position, entity|
          entity.place(game_map, x: position.x, y: position.y)
        end
      }
    end

    def build_entity(name = nil)
      Entity::BaseEntity.new(
        :entity,
        x: nil, y: nil,
        name: name || 'An entity'
      )
    end

    def build_combatant(name, hp:, power:, defense:)
      Entity::Actor.new(
        :combatant,
        x: nil, y: nil,
        name: name,
        combatant: { hp: hp, max_hp: hp, defense: defense, power: power }
      )
    end
  end
end
