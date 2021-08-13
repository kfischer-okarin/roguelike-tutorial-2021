module Scenes
  class BaseScene
    attr_reader :input_event_handler

    def initialize
      @input_event_handler = build_input_handler
    end

    def render(console)
      # no op
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

    protected

    def build_input_handler
      BaseInputHandler.new
    end
  end
end
