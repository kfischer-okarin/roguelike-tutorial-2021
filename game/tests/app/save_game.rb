require 'tests/test_helper.rb'

def test_save_game_stores_game_world(_args, assert)
  SaveGameTest.with_file_mock do
    game_world_before = $game.game_world
    $game.game_world.data.current_floor = 7
    $game.game_world.data.seed = 'ABC'

    SaveGame.save
    SaveGame.load

    assert.not_equal! $game.game_world, game_world_before
    assert.equal! $game.game_world.current_floor, 7
    assert.equal! $game.game_world.seed, 'ABC'
  end
end

def test_save_game_stores_game_map(_args, assert)
  SaveGameTest.with_file_mock do
    game_map_before = build_game_map(width: 25, height: 25, tiles: { [3, 3] => :wall })
    Entities.player.place(game_map_before, x: 0, y: 0)
    $game.game_map = game_map_before
    $state.game_map = game_map_before.data

    SaveGame.save
    SaveGame.load

    assert.not_equal! $game.game_map, game_map_before
    assert.has_attributes! $game.game_map, width: 25, height: 25
    assert.true! $game.game_map.explored?(0, 0)
    assert.false! $game.game_map.explored?(24, 24)
    assert.false! $game.game_map.walkable?(3, 3)
  end
end

def test_save_game_stores_entities(_args, assert)
  SaveGameTest.with_file_mock do
    enemy_item = build_item
    enemy = build_actor(items: [enemy_item])
    player = Entities.player
    game_map = build_game_map_with_entities(enemy, player)
    $game.game_map = game_map
    $state.game_map = game_map.data

    SaveGame.save
    SaveGame.load

    loaded_enemy = Entities.get(enemy.id)
    loaded_enemy_item = Entities.get(enemy_item.id)
    loaded_player = Entities.player

    assert.not_equal! loaded_enemy, enemy
    assert.not_equal! loaded_enemy_item, enemy_item
    assert.not_equal! loaded_player, player
    assert.contains_exactly! Entities, [loaded_enemy, loaded_player, loaded_enemy_item]
    assert.equal! loaded_enemy.inventory.items, [loaded_enemy_item]
    assert.equal! loaded_enemy_item.parent, loaded_enemy.inventory
    assert.contains_exactly! $game.game_map.entities, [loaded_enemy, loaded_player]
  end
end

def test_save_game_stores_message_log(_args, assert)
  SaveGameTest.with_file_mock do
    $message_log.add_message(text: 'Test message', fg: [100, 200, 100])
    $message_log.add_message(text: 'Another Test message')
    $message_log.add_message(text: 'Another Test message')
    messages_before = $message_log.messages

    SaveGame.save
    SaveGame.load

    assert.not_equal! messages_before, $message_log.messages
    assert.equal! messages_before.size, $message_log.messages.size
    assert.has_attributes! $message_log.messages[0], text: 'Test message', fg: [100, 200, 100]
    assert.has_attributes! $message_log.messages[1],
                           text: 'Another Test message',
                           fg: [255, 255, 255],
                           receive_count: 2
  end
end

module SaveGameTest
  def self.with_file_mock
    file_content = nil
    game_map = build_game_map
    Entities.player.place(game_map, x: 0, y: 0)
    $game.game_map = game_map
    $state.game_map = game_map.data
    with_replaced_method SaveGame, :read_save_file, -> { file_content } do
      with_replaced_method SaveGame, :write_save_file, ->(content) { file_content = content } do
        yield
      end
    end
  end
end
