module Scenes
  class HistoryViewer < BaseScene
    attr_reader :cursor_index

    def initialize(previous_scene:, console:)
      @previous_scene = previous_scene
      super()
      @messages = $message_log.messages
      @cursor_index = @messages.size - 1
      @log_console = Engine::Console.new(console.width - 6, console.height - 6)
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
      @previous_scene.render(console)

      @log_console.draw_frame(x: 0, y: 0, width: @log_console.width, height: @log_console.height)
      @log_console.print_box_centered(
        x: 0, y: 0, width: @log_console.width, height: 1,
        string: '┤Message history├'
      )
      @message_log.messages = $message_log.messages[0..@cursor_index]
      @message_log.render(@log_console)

      @log_console.blit(console, x: 3, y: 3)
    end

    protected

    def build_input_handler
      InputEventHandler.new(self)
    end

    class InputEventHandler < BaseInputHandler
      def initialize(viewer)
        super()
        @viewer = viewer
      end

      def dispatch_action_for_quit
        $game.pop_scene
        nil
      end

      alias dispatch_action_for_view_history dispatch_action_for_quit
      alias dispatch_action_for_wait dispatch_action_for_quit

      def dispatch_action_for_up
        @viewer.cursor_index -= 1
        nil
      end

      def dispatch_action_for_down
        @viewer.cursor_index += 1
        nil
      end

      def dispatch_action_for_page_up
        @viewer.cursor_index -= 10
        nil
      end

      def dispatch_action_for_page_down
        @viewer.cursor_index += 10
        nil
      end

      def dispatch_action_for_home
        @viewer.cursor_index = 0 # will be clamped to real value
        nil
      end

      def dispatch_action_for_end
        @viewer.cursor_index = @viewer.message_count - 1
        nil
      end

      def dispatch_action_for_help
        $game.show_help('Message Log')
        nil
      end
    end
  end
end
