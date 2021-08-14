module Serializer
  class << self
    def serialize(schema, value)
      [
        $gtk.serialize_state(schema),
        serializer_for(schema).serialize(value)
      ].join("\n")
    end

    def deserialize(value)
      Deserialization.new(value).result
    end

    def serializer_for(schema)
      serializer_class(schema[:type]).new(schema)
    end

    private

    def serializer_class(type)
      SERIALIZER_CLASSES.fetch(type)
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
      Serializer.serializer_for(schema).deserialize(value)
    end
  end

  class BaseSerializer
    def initialize(schema)
      @schema = schema
    end
  end

  class IntSerializer < BaseSerializer
    def serialize(value)
      value.to_s
    end

    def deserialize(value)
      value.to_i
    end
  end

  class StringSerializer < BaseSerializer
    def serialize(value)
      value
    end

    def deserialize(value)
      value
    end
  end

  class SymbolSerializer < BaseSerializer
    def serialize(value)
      value.to_s
    end

    def deserialize(value)
      value.to_sym
    end
  end

  class BooleanSerializer < BaseSerializer
    def serialize(value)
      value ? 't' : 'f'
    end

    def deserialize(value)
      value == 't'
    end
  end

  class TypedArraySerializer < BaseSerializer
    def serialize(value)
      value.map { |element|
        element_serializer.serialize(element)
      }.join(',')
    end

    def deserialize(value)
      value.split(',').map { |element|
        element_serializer.deserialize(element)
      }
    end

    private

    def element_serializer
      @element_serializer ||= Serializer.serializer_for(type: @schema[:element_type])
    end
  end

  class EntitySerializer < BaseSerializer
    def serialize(value)
      $gtk.serialize_state value
    end

    def deserialize(value)
      $gtk.deserialize_state value
    end
  end

  SERIALIZER_CLASSES = {
    int: IntSerializer,
    string: StringSerializer,
    symbol: SymbolSerializer,
    boolean: BooleanSerializer,
    typed_array: TypedArraySerializer,
    entity: EntitySerializer
  }
end
