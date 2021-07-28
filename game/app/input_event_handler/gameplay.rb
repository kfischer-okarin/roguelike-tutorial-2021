module InputEventHandler
  class Gameplay < BaseInputHandler
    def initialize(game_map:, player:)
      super()
      @game_map = game_map
      @player = player
      update_fov
    end

    def handle_input_events(input_events)
      input_events.each do |event|
        action = dispatch_action_for(event)
        next unless action

        action.perform
        handle_enemy_turns
        update_fov
      end
    end

    protected

    def dispatch_action_for_up
      BumpIntoEntityAction.new(@player, dx: 0, dy: 1)
    end

    def dispatch_action_for_down
      BumpIntoEntityAction.new(@player, dx: 0, dy: -1)
    end

    def dispatch_action_for_left
      BumpIntoEntityAction.new(@player, dx: -1, dy: 0)
    end

    def dispatch_action_for_right
      BumpIntoEntityAction.new(@player, dx: 1, dy: 0)
    end

    def dispatch_action_for_up_right
      BumpIntoEntityAction.new(@player, dx: 1, dy: 1)
    end

    def dispatch_action_for_up_left
      BumpIntoEntityAction.new(@player, dx: -1, dy: 1)
    end

    def dispatch_action_for_down_right
      BumpIntoEntityAction.new(@player, dx: 1, dy: -1)
    end

    def dispatch_action_for_down_left
      BumpIntoEntityAction.new(@player, dx: -1, dy: -1)
    end

    def dispatch_action_for_wait
      WaitAction
    end

    private

    def handle_enemy_turns
      @game_map.actors.each do |entity|
        entity.ai.perform_action
      end
    end

    def update_fov
      @game_map.update_fov(x: @player.x, y: @player.y, radius: 8)
    end
  end
end
