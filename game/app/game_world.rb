class GameWorld < DataBackedObject
  data_reader :current_floor, :seed

  def initialize(data)
    super()
    @data = data

    self.current_floor ||= 0
    self.seed ||= RNG.new_string_seed
  end

  def generate_next_floor
    self.current_floor += 1
    delete_all_player_unrelated_entities

    $game.game_map = Procgen.generate_dungeon(
      map_width: 80,
      map_height: 40,
      parameters: Procgen::DungeonGenerator::Parameters.new(
        max_rooms: 10,
        min_room_size: 6,
        max_room_size: 10,
        max_monsters_per_room: 2,
        max_items_per_room: 2
      ),
      player: Entities.player,
      seed: "#{seed}#{current_floor}"
    )
    $state.game_map = $game.game_map.data
  end

  private

  data_writer :current_floor, :seed

  def delete_all_player_unrelated_entities
    return unless $game.game_map

    entities_to_delete = $game.game_map.entities.reject { |entity|
      entity == Entities.player
    }
    entities_to_delete.each do |entity|
      Entities.delete entity
    end
  end
end
