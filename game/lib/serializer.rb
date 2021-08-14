module Serializer
  class << self
    def serialize(schema, value)
      [
        $gtk.serialize_state(schema),
        value.to_s
      ].join("\n")
    end

    def deserialize(value)
      Deserialization.new(value).result
    end
  end

  class Deserialization
    attr_reader :result

    def initialize(value)
      @lines = value.split("\n")
      @index = 0
      @result = read_next_value
    end

    private

    def read_next_value
      schema = read_schema
      next_line
      read_typed_value(current_line, schema).tap {
        next_line
      }
    end

    def read_schema
      $gtk.deserialize_state current_line
    end

    def current_line
      @lines[@index]
    end

    def next_line
      @index += 1
    end

    def read_typed_value(value, schema)
      send(:"read_#{schema[:type]}", value, schema)
    end

    def read_int(value, _schema)
      value.to_i
    end

    def read_string(value, _schema)
      value
    end

    def read_symbol(value, _schema)
      value.to_sym
    end
  end
end
