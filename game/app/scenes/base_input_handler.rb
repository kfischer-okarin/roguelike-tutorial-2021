module Scenes
  class BaseInputHandler
    def handle_input_event(event)
      method_name = :"dispatch_action_for_#{event.type}"
      return unless respond_to? method_name

      handler = method(method_name)
      if handler.arity == 1
        handler.call(event)
      else
        handler.call
      end
    end
  end
end
