module Scenes
  class BaseScene
    attr_reader :input_event_handler

    def initialize
      @input_event_handler = build_input_handler
    end

    def handle_input_event(input_event)
      input_event_handler.handle_input_event(input_event)
    end

    def handle_input_events(input_events)
      input_events.each do |event|
        action = handle_input_event(event)
        next unless handle_action(action)

        after_action_performed
      end
    end

    def handle_action(action)
      return false unless action

      action.perform
      true
    rescue Action::Impossible => e
      $message_log.add_message(text: e.message, fg: Colors.action_impossible)
      false
    end

    def after_action_performed
      # no op
    end

    protected

    def build_input_handler
      BaseInputHandler.new
    end
  end
end
