module InputEventHandler
  class BaseInputHandler
    def dispatch_action_for(event)
      method_name = :"dispatch_action_for_#{event.type}"
      send(method_name) if respond_to? method_name
    end

    protected

    def dispatch_action_for_quit
      EscapeAction
    end
  end
end
