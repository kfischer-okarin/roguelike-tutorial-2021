def test_melee_action_deal_damage(_args, assert)
  TestHelper.init_globals
  attacker = TestHelper.build_combatant('Attacker', hp: 30, defense: 2, power: 5)
  defender = TestHelper.build_combatant('Defender', hp: 30, defense: 1, power: 3)
  TestHelper.build_map(
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
  TestHelper.build_map(
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
  TestHelper.build_map(
    [3, 3] => attacker
  )

  assert.raises_with_message!(Action::Impossible, 'Nothing to attack.') do
    MeleeAction.new(attacker, dx: 0, dy: -1).perform
  end
end

module TestHelper
  class << self
    def init_globals
      $message_log = MessageLog.new
    end

    def log_messages
      $message_log.messages.map(&:text)
    end

    def build_map(entities_by_position)
      width = entities_by_position.keys.map(&:x).max + 1
      height = entities_by_position.keys.map(&:y).max + 1
      game_map = GameMap.new(width: width, height: height, entities: [])
      entities_by_position.each do |position, entity|
        entity.place(game_map, x: position.x, y: position.y)
      end
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

module GTK
  class Assert
    def includes!(collection, element, message = nil)
      @assertion_performed = true
      return if collection.include? element

      raise "Collection:\n  #{collection.inspect}\n\ndid not contain:\n  #{element}\n#{message}."
    end

    def raises_with_message!(exception_class, exception_message, message = nil)
      @assertion_performed = true

      expected_description = "#{exception_class} with #{exception_message.inspect}"
      begin
        yield
        raise "Expected:\n  #{expected_description}\n\nto be raised, but nothing was raised.\n #{message}."
      rescue exception_class => e
        return if e.message == exception_message

        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      rescue StandardError => e
        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      end
    end

    private

    def exception_description(exception)
      "#{exception.class} with #{exception.message.inspect}"
    end
  end
end
