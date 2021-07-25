require 'app/actions.rb'

module InputEventHandler
  class << self
    def dispatch_action_for(event)
      send(:"dispatch_action_for_#{event.type}")
    end

    private

    def dispatch_action_for_quit
      EscapeAction
    end

    def dispatch_action_for_up
      BumpIntoEntityAction.new($game.player, dx: 0, dy: 1)
    end

    def dispatch_action_for_down
      BumpIntoEntityAction.new($game.player, dx: 0, dy: -1)
    end

    def dispatch_action_for_left
      BumpIntoEntityAction.new($game.player, dx: -1, dy: 0)
    end

    def dispatch_action_for_right
      BumpIntoEntityAction.new($game.player, dx: 1, dy: 0)
    end
  end
end
