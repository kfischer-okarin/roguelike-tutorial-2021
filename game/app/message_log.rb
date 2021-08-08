class MessageLog
  attr_reader :messages

  def initialize
    @messages = []
  end

  def add_message(text:, fg: nil, stack: true)
    last_message = @messages.last
    if stack && last_message&.text == text
      last_message.count += 1
      return
    end

    @messages << Message.new(text: text, fg: fg || Colors.white)
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
