require 'tests/test_helper.rb'

def test_serializer_serialize_int(_args, assert)
  expected = <<-SERIALIZED
{:type=>:int}
3
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
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
    [1, 2, 3, 4, 5, 6, 7, 8, 12],
    expected
  )
end

def test_serializer_serialize_entity(args, assert)
  entity = args.state.new_entity_strict(:player, hp: 12, max_hp: 13)
  expected = <<-SERIALIZED
{:type=>:entity}
{:created_at=>-1, :entity_keys_by_ref=>{:global_created_at_elapsed=>:created_at, :entity_name=>:entity_type}, :entity_type=>:player, :max_hp=>13, :hp=>12, :entity_name=>:player, :global_created_at_elapsed=>-1, :entity_id=>#{entity.entity_id}, :entity_strict=>true}
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    entity,
    expected,
    compare_by: ->(value) { value.to_hash }
  )
end

def test_serializer_serialize_array(args, assert)
  expected = <<-SERIALIZED
{:type=>:array, :size=>3}
{:type=>:string}
Morty
{:type=>:symbol}
somewhere
{:type=>:int}
33
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    ['Morty', :somewhere, 33],
    expected
  )
end

def test_serializer_serialize_empty_array(args, assert)
  expected = <<-SERIALIZED
{:type=>:array, :size=>0}
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    [],
    expected
  )
end

def test_serializer_serialize_hash(args, assert)
  expected = <<-SERIALIZED
{:type=>:hash, :size=>3}
{:type=>:symbol}
name
{:type=>:string}
Jeff
{:type=>:symbol}
combatant
{:type=>:array, :size=>2}
{:type=>:symbol}
hp
{:type=>:int}
1
{:type=>:symbol}
inventory
{:type=>:array, :size=>0}
SERIALIZED

  SerializationTest.assert_serialized_value!(
    assert,
    { name: 'Jeff', combatant: [:hp, 1], inventory: [] },
    expected
  )
end

module SerializationTest
  class << self
    def assert_serialized_value!(assert, value, expected, compare_by: nil)
      serialized = Serializer.serialize(value)

      assert.equal! serialized, expected.strip, 'Serialized value was different'

      deserialized = Serializer.deserialize serialized

      transform = compare_by || ->(a) { a }
      assert.equal! transform.call(deserialized), transform.call(value), 'Deserialized value was different'
    end
  end
end
