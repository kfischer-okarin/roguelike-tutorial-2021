class Game
  attr_reader :game_map

  def initialize(entities:, input_event_handler:, game_map:, player:)
    @entities = entities
    @input_event_handler = input_event_handler
    @game_map = game_map
    @player = player
  end

  def handle_input_events(input_events)
    input_events.each do |event|
      action = @input_event_handler.dispatch_action_for(event)
      next unless action

      action.perform(self, @player)
    end
  end

  def render(terminal)
    terminal.clear
    @game_map.render(terminal, offset_y: 5)
    @entities.each do |entity|
      terminal.print(x: entity.x, y: entity.y + 5, string: entity.char, fg: entity.color)
    end
    terminal.render
  end
end
