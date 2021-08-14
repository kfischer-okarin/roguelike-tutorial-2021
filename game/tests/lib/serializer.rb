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

def test_serializer_serialize_true(_args, assert)
  expected = <<-SERIALIZED
{:type=>:boolean}
t
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :boolean },
    true,
    expected
  )
end

def test_serializer_serialize_false(_args, assert)
  expected = <<-SERIALIZED
{:type=>:boolean}
f
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :boolean },
    false,
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

def test_serializer_serialize_entity(args, assert)
  entity = args.state.new_entity_strict(:player, hp: 12, max_hp: 13)
  expected = <<-SERIALIZED
{:type=>:entity}
{:entity_id=>#{entity.entity_id}, :entity_name=>:player, :entity_type=>:player, :created_at=>-1, :global_created_at_elapsed=>-1, :entity_strict=>true, :entity_keys_by_ref=>{:entity_type=>:entity_name, :global_created_at_elapsed=>:created_at}, :hp=>12, :max_hp=>13}
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { type: :entity },
    entity,
    expected,
    compare_by: ->(value) { value.to_hash }
  )
end

module SerializationTest
  class << self
    def assert_serialized_value!(assert, schema, value, expected, compare_by: nil)
      serialized = Serializer.serialize(schema, value)

      assert.equal! serialized, expected.strip, 'Serialized value was different'

      deserialized = Serializer.deserialize serialized

      transform = compare_by || ->(a) { a }
      assert.equal! transform.call(deserialized), transform.call(value), 'Deserialized value was different'
    end
  end
end
