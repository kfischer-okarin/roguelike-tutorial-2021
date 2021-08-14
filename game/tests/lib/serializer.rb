require 'tests/test_helper.rb'

def test_serializer_serialize_int(_args, assert)
  expected = <<-SERIALIZED
{:type=>:int}
3
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :int },
    3,
    expected
  )
end

def test_serializer_serialize_string(_args, assert)
  expected = <<-SERIALIZED
{:type=>:string}
Rick
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :string },
    'Rick',
    expected
  )
end

def test_serializer_serialize_symbol(_args, assert)
  expected = <<-SERIALIZED
{:type=>:symbol}
hp
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :symbol },
    :hp,
    expected
  )
end

def test_serializer_serialize_typed_array(_args, assert)
  expected = <<-SERIALIZED
{:type=>:typed_array, :element_type=>:int}
1,2,3,4,5,6,7,8,12
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :typed_array, element_type: :int },
    [1, 2, 3, 4, 5, 6, 7, 8, 12],
    expected
  )
end


module SerializationTest
  class << self
    def assert_serialized_value!(assert, schema, value, expected)
      serialized = Serializer.serialize(schema, value)

      assert.equal! serialized, expected.strip, 'Serialized value was different'

      deserialized = Serializer.deserialize serialized

      assert.equal! deserialized, value
    end
  end
end
