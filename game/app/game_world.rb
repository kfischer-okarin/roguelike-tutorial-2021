class GameWorld < DataBackedObject
  data_reader :map_width, :map_height, :procgen_parameters
  data_accessor :current_floor

  def initialize(data)
    super()
    @data = data
    require_data_keys! %i[
      map_width
      map_height
      procgen_parameters
    ]

    self.current_floor ||= 0
  end

  def generate_next_floor
    self.current_floor += 1
    delete_all_player_unrelated_entities

    $game.game_map = Procgen.generate_dungeon(
      map_width: map_width,
      map_height: map_height,
      parameters: procgen_parameters,
      player: Entities.player
    )
    $state.game_map = $game.game_map.data
  end

  private

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
