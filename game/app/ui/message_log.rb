module UI
  class MessageLog
    attr_accessor :x, :y, :width, :height, :messages

    def initialize(x:, y:, width:, height:)
      @x = x
      @y = y
      @width = width
      @height = height
    end

    def render(console)
      y_offset = 0
      message_index = messages.length - 1
      loop do
        return if message_index.negative?

        message = messages[message_index]
        message.full_text.wrapped_lines(@width).reverse_each do |line|
          console.print(x: @x, y: @y + y_offset, string: line.strip, fg: message.fg)
          y_offset += 1
          return if y_offset >= @height
        end
        message_index -= 1
      end
    end
  end
end
