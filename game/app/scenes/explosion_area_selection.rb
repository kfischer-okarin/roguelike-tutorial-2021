module Scenes
  class ExplosionAreaSelection < PositionSelection
    def initialize(gameplay_scene, radius:, &build_action_for_selected)
      super(gameplay_scene, &build_action_for_selected)
      @radius = radius
      @target_positions = {}
    end

    protected

    def render_selection(console)
      return unless valid_position? $game.cursor_position

      center = ScreenLayout.console_to_map_position $game.cursor_position

      target_positions(center).each do |position|
        x, y = ScreenLayout.map_to_console_position position
        console.bg[x, y] = Colors.white
        console.fg[x, y] = Colors.black
      end
    end

    private

    def target_positions(center)
      @target_positions[center] ||= calc_target_positions(center)
    end

    def calc_target_positions(center)
      game_map = $game.game_map
      game_map.positions_in_radius(center: center, radius: @radius) { |position|
        next false unless game_map.in_bounds?(position.x, position.y)
        next true if !game_map.explored?(position.x, position.y)

        game_map.walkable?(position.x, position.y)
      }.tap { |result|
        result << center
      }
    end
  end
end
