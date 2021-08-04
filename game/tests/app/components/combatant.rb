def test_combatant_heal(_args, assert)
  entity = TestHelper::EntityStub.new
  combatant = Components::Combatant.new(entity, { hp: 5, max_hp: 10 })

  healed_amount = combatant.heal(2)

  assert.equal! combatant.hp, 7
  assert.equal! healed_amount, 2

  healed_amount = combatant.heal(20)

  assert.equal! combatant.hp, 10
  assert.equal! healed_amount, 3
end

def test_combatant_take_damage(_args, assert)
  entity = TestHelper::EntityStub.new
  combatant = Components::Combatant.new(entity, { hp: 5, max_hp: 10 })

  combatant.take_damage(2)

  assert.equal! combatant.hp, 3
  assert.false! entity.died?

  combatant.take_damage(20)

  assert.equal! combatant.hp, 0
  assert.true! entity.died?
end

module TestHelper
  class EntityStub
    def die
      @died = true
    end

    def died?
      @died || false
    end
  end
end
