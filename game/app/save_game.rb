module SaveGame
  class << self
    def save
      $gtk.write_file 'map.sav', [
        $state.game_map.width.to_s,
        $state.game_map.height.to_s,
        $state.game_map.tiles.map(&:inspect).join(','),
        $state.game_map.explored.map(&:inspect).join(',')
      ].join("\n")
      entity_rows = [
        $state.entities.player_id.to_s
      ]
      entity_rows += $state.entities.entities_by_id.values.map { |value| $gtk.serialize_state(value) }
      $gtk.write_file 'entities.sav', entity_rows.join("\n")
      $gtk.write_file 'message_log.sav', $gtk.serialize_state($state.message_log)
    end

    def load
      loaded_map_data = $gtk.read_file 'map.sav'
      return if loaded_map_data == 'nil'

      width, height, tiles, explored = loaded_map_data.split("\n")
      $state.game_map.width = width.to_i
      $state.game_map.height = height.to_i
      $state.game_map.tiles = tiles.split(',').map { |value| value[1..-1].to_sym }
      $state.game_map.explored = explored.split(',').map { |value| value == 'true' }
      game_map = GameMap.new($state.game_map)

      entity_rows = $gtk.read_file('entities.sav').split("\n")
      $state.entities = Entities.build_data
      $state.entities.player_id = entity_rows[0].to_i
      entity_rows[1..-1].each do |row|
        entity = $gtk.deserialize_state row
        $state.entities.entities_by_id[entity.entity_id] = entity
      end
      Entities.data = $state.entities
      Entities.each do |entity|
        parent = entity.parent || game_map
        entity.place(parent, x: entity.x, y: entity.y)
      end

      $game.player = Entities.player
      $game.game_map = game_map
      $game.scene = Scenes::Gameplay.new(player: Entities.player)

      $state.message_log = $gtk.deserialize_state $gtk.read_file('message_log.sav')
      $message_log = MessageLog.new $state.message_log.messages
    end

    def delete
      $gtk.write_file 'map.sav', 'nil'
      $gtk.write_file 'entities.sav', 'nil'
      $gtk.write_file 'message_log.sav', 'nil'
    end
  end
end
