module InputEventHandler
  class GameOver < BaseInputHandler
    def handle_input_events(input_events)
      input_events.each do |event|
        action = dispatch_action_for(event)
        next unless action

        action.perform
      end
    end
  end
end
