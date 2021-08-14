class MessageLog
  attr_reader :messages

  def initialize(data)
    @data = data
    @messages = data.map { |message_data| Message.new(message_data) }
  end

  def add_message(text:, fg: nil, stack: true)
    last_message = @messages.last
    if stack && last_message&.text == text
      last_message.receive_count += 1
      return
    end

    new_message = Message.new(text: text, fg: fg || Colors.white, receive_count: 1)
    @messages << new_message
    @data << new_message.data
  end

  class Message < DataBackedObject
    data_reader :text, :fg
    data_accessor :receive_count

    def initialize(data)
      super()
      @data = data
    end

    def full_text
      return text unless receive_count > 1

      "#{text} (#{receive_count})"
    end
  end
end
