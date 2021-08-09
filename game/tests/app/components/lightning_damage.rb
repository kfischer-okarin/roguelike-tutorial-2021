require 'tests/test_helper.rb'

def test_lightning_damage_hits_closest_actor(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_item
  lightning_damage = Components::LightningDamage.new(item, amount: 5, maximum_range: 5)
  npc = TestHelper.build_actor('NPC', hp: 20)
  item.place npc.inventory
  closer_monster = TestHelper.build_actor('Close Monster', hp: 30) 
  far_monster = TestHelper.build_actor('Far Monster', hp: 30)
  game_map = TestHelper.build_map_with_entities(
    [5, 5] => npc,
    [6, 7] => closer_monster,
    [1, 1] => far_monster
  )
  game_map.define_singleton_method :visible? do |_x, _y|
    true
  end

  lightning_damage.activate(npc)

  assert.includes! TestHelper.log_messages, 'A lightning bolt strikes the Close Monster with a loud thunder, for 5 damage!'
  assert.equal! closer_monster.combatant.hp, 25
  assert.equal! far_monster.combatant.hp, 30
  assert.includes_no! npc.inventory.items, item
end

def test_lightning_damage_cannot_hit_outside_maximum_range(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_item
  lightning_damage = Components::LightningDamage.new(item, amount: 5, maximum_range: 2)
  npc = TestHelper.build_actor('NPC', hp: 20)
  item.place npc.inventory
  far_monster = TestHelper.build_actor('Far Monster', hp: 30)
  game_map = TestHelper.build_map_with_entities(
    [5, 5] => npc,
    [1, 1] => far_monster
  )
  game_map.define_singleton_method :visible? do |_x, _y|
    true
  end

  assert.raises_with_message! Action::Impossible, 'No enemy is close enough to strike.' do
    lightning_damage.activate(npc)
  end
  assert.equal! far_monster.combatant.hp, 30
  assert.includes! npc.inventory.items, item
end

def test_lightning_damage_cannot_hit_without_target(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_item
  lightning_damage = Components::LightningDamage.new(item, amount: 5, maximum_range: 2)
  npc = TestHelper.build_actor('NPC', hp: 20)
  item.place npc.inventory
  game_map = TestHelper.build_map_with_entities(
    [5, 5] => npc
  )
  game_map.define_singleton_method :visible? do |_x, _y|
    true
  end

  assert.raises_with_message! Action::Impossible, 'No enemy is close enough to strike.' do
    lightning_damage.activate(npc)
  end
  assert.includes! npc.inventory.items, item
end

def test_lightning_damage_cannot_hit_non_visible_targets(args, assert)
  TestHelper.init_globals(args)
  item = TestHelper.build_item
  lightning_damage = Components::LightningDamage.new(item, amount: 5, maximum_range: 2)
  npc = TestHelper.build_actor('NPC', hp: 20)
  closer_monster = TestHelper.build_actor('Close Monster', hp: 30)
  item.place npc.inventory
  game_map = TestHelper.build_map_with_entities(
    [5, 5] => npc,
    [5, 6] => closer_monster
  )
  game_map.define_singleton_method :visible? do |x, y|
    x != closer_monster.x || y != closer_monster.y
  end

  assert.raises_with_message! Action::Impossible, 'No enemy is close enough to strike.' do
    lightning_damage.activate(npc)
  end
  assert.equal! closer_monster.combatant.hp, 30
  assert.includes! npc.inventory.items, item
end
