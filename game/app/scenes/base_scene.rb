module Scenes
  class BaseScene
    attr_reader :input_event_handler

    def initialize
      @input_event_handler = build_input_handler
    end

    def handle_input_event(input_event)
      method_name = :"dispatch_action_for_#{input_event.type}"
      return unless input_event_handler.respond_to? method_name

      handler = input_event_handler.method(method_name)
      if handler.arity == 1
        handler.call(input_event)
      else
        handler.call
      end
    end

    def handle_action(action)
      return false unless action.respond_to? :perform

      action.perform
      true
    rescue Action::Impossible => e
      $message_log.add_message(text: e.message, fg: Colors.action_impossible)
      false
    end

    protected

    def build_input_handler
      BaseInputHandler.new
    end
  end
end
