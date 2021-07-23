class Game
  def initialize(entities:, input_event_handler:, player:)
    @entities = entities
    @input_event_handler = input_event_handler
    @player = player
  end

  def handle_input_events(input_events)
    input_events.each do |event|
      action = @input_event_handler.dispatch_action_for(event)
      next unless action

      action.execute(@entities)
    end
  end

  def render(terminal)
    terminal.clear
    @entities.each do |entity|
      terminal.print(x: entity.x, y: entity.y, string: entity.char, fg: entity.color)
    end
    terminal.render
  end
end
