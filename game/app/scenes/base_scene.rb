module Scenes
  class BaseScene
    def handle_input_events(input_events)
      input_events.each do |event|
        action = input_event_handler.handle_input_event(event)
        next unless action

        action.perform
        after_action_performed
      end
    end

    def after_action_performed
      # no op
    end
  end
end
