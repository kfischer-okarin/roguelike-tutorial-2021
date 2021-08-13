module Scenes
  class BaseScene
    def render(console)
      # no op
    end

    def handle_input_event(input_event)
      method_name = :"dispatch_action_for_#{input_event.type}"
      return unless respond_to? method_name

      handler = method(method_name)
      if handler.arity == 1
        handler.call(input_event)
      else
        handler.call
      end
    end

    protected

    def push_scene(scene)
      $game.push_scene scene
    end

    def pop_scene
      $game.pop_scene
    end
  end
end
