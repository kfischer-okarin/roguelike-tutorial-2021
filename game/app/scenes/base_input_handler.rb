module Scenes
  class BaseInputHandler
    def handle_input_event(event)
      method_name = :"dispatch_action_for_#{event.type}"
      send(method_name) if respond_to? method_name
    end
  end
end
