module UI
  class MessageLog
    def initialize
      @messages = []
    end

    def add_message(text:, fg:, stack: true)
      last_message = @messages.last
      if stack && last_message&.text == text
        last_message.count += 1
        return
      end

      @messages << Message.new(text: text, fg: fg)
    end

    def render(terminal, x:, y:, width:, height:)
      y_offset = 0
      message_index = @messages.length - 1
      loop do
        return if message_index.negative?

        message = @messages[message_index]
        message.full_text.wrapped_lines(width).reverse_each do |line|
          terminal.print(x: x, y: y + y_offset, string: line.strip, fg: message.fg)
          y_offset += 1
          return if y_offset >= height
        end
        message_index -= 1
      end
    end

    class Message
      attr_reader :text, :fg
      attr_accessor :count

      def initialize(text:, fg:)
        @text = text
        @fg = fg
        @count = 1
      end

      def full_text
        return @text unless @count > 1

        "#{@text} (#{@count})"
      end
    end
  end
end
