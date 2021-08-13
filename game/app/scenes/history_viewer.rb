module Scenes
  class HistoryViewer < BaseScene
    attr_accessor :cursor_index

    def initialize
      super()
      @messages = $message_log.messages
      @cursor_index = @messages.size - 1
      @log_console = Engine::Console.new($console.width - 6, $console.height - 6)
      @message_log = UI::MessageLog.new(x: 1, y: 1, width: @log_console.width - 2, height: @log_console.height - 2)
    end

    def message_count
      @messages.size
    end

    def cursor_index=(value)
      min_cursor_index = [@messages.size - 1, @message_log.height - 1].min
      @cursor_index = value.clamp(min_cursor_index, @messages.size - 1)
    end

    def render(console)
      @log_console.draw_frame(x: 0, y: 0, width: @log_console.width, height: @log_console.height)
      @log_console.print_box_centered(
        x: 0, y: 0, width: @log_console.width, height: 1,
        string: '┤Message history├'
      )
      @message_log.messages = $message_log.messages[0..@cursor_index]
      @message_log.render(@log_console)

      @log_console.blit(console, x: 3, y: 3)
    end

    def dispatch_action_for_quit
      $game.pop_scene
    end

    alias dispatch_action_for_view_history dispatch_action_for_quit
    alias dispatch_action_for_wait dispatch_action_for_quit

    def dispatch_action_for_up
      self.cursor_index -= 1
    end

    def dispatch_action_for_down
      self.cursor_index += 1
    end

    def dispatch_action_for_page_up
      self.cursor_index -= 10
    end

    def dispatch_action_for_page_down
      self.cursor_index += 10
    end

    def dispatch_action_for_home
      self.cursor_index = 0 # will be clamped to real value
    end

    def dispatch_action_for_end
      self.cursor_index = message_count - 1
    end

    def dispatch_action_for_help
      $game.show_help('Message Log')
    end
  end
end
