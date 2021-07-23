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
      MovementAction.new(0, 1)
    end

    def dispatch_action_for_down
      MovementAction.new(0, -1)
    end

    def dispatch_action_for_left
      MovementAction.new(-1, 0)
    end

    def dispatch_action_for_right
      MovementAction.new(1, 0)
    end
  end
end