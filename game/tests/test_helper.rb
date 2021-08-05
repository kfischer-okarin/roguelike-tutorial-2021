module GTK
  class Assert
    def includes!(collection, element, message = nil)
      @assertion_performed = true
      return if collection.include? element

      raise "Collection:\n  #{collection.inspect}\n\ndid not contain:\n  #{element}\n#{message}."
    end

    def raises_with_message!(exception_class, exception_message, message = nil)
      @assertion_performed = true

      expected_description = "#{exception_class} with #{exception_message.inspect}"
      begin
        yield
        raise "Expected:\n  #{expected_description}\n\nto be raised, but nothing was raised.\n #{message}."
      rescue exception_class => e
        return if e.message == exception_message

        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      rescue StandardError => e
        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      end
    end

    private

    def exception_description(exception)
      "#{exception.class} with #{exception.message.inspect}"
    end
  end
end

module TestHelper
  class << self
    def init_globals
      $message_log = MessageLog.new
    end

    def log_messages
      $message_log.messages.map(&:text)
    end
  end
end
