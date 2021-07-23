class Game
  def initialize(entities:, input_event_handler:, player:)
    @entities = entities
    @input_event_handler = input_event_handler
    @player = player
  end

  def handle_input_events(args, input_events)
    input_events.each do |event|
      action = @input_event_handler.dispatch_action_for(event)
      next unless action

      action.execute(args)
    end
  end
end
