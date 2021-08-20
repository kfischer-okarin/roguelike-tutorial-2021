module SaveGame
  FILENAME = 'save_game.sav'.freeze

  class << self
    def save
      save_game_data = {
        game_world: $state.game_world,
        map: $state.game_map,
        entities: $state.entities,
        message_log: $state.message_log
      }
      write_save_file Serializer.serialize(save_game_data)
    end

    def load
      save_game_data = Serializer.deserialize read_save_file

      $state.game_map = save_game_data[:map]
      game_map = GameMap.new($state.game_map)

      $state.entities = save_game_data[:entities]
      Entities.data = $state.entities
      Entities.each do |entity|
        parent = entity.parent || game_map
        entity.place(parent, x: entity.x, y: entity.y)
      end

      $state.message_log = save_game_data[:message_log]
      $message_log = MessageLog.new $state.message_log

      $state.game_world = save_game_data[:game_world]
      game_world = GameWorld.new($state.game_world)

      $game.player = Entities.player
      $game.game_map = game_map
      $game.game_world = game_world
      $game.scene = Scenes::Gameplay.new(player: Entities.player)
    end

    def exists?
      save_file = read_save_file
      save_file && save_file != 'nil'
    end

    def read_save_file
      $gtk.read_file FILENAME
    end

    def write_save_file(content)
      $gtk.write_file FILENAME, content
    end

    def delete
      $gtk.write_file FILENAME, 'nil'
    end
  end
end
