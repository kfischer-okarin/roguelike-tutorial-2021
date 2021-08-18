require 'tests/test_helper.rb'

def test_rng_int_seed_from_string_seed(_args, assert)
  # 36 digit system like hexadecimal
  assert.equal! RNG.int_seed_from_string_seed('CBA3'), 3 + 10 * 36 + 11 * 36**2 + 12 * 36**3
end

def test_rng_random_element_from(_args, assert)
  rng = RNG.new

  RNGTestHelper.with_int_between_stub(rng, result: 1) do |int_between_calls|
    result = rng.random_element_from(['a', 'b', 'c'])

    assert.equal! int_between_calls, [[0, 2]]
    assert.equal! result, 'b'
  end
end

def test_rng_random_from_weighted_elements(_args, assert)
  rng = RNG.new
  weighted_elements = { 'a' => 20, 'b' => 50 }

  RNGTestHelper.with_int_between_stub(rng, result: 0) do |int_between_calls|
    result = rng.random_from_weighted_elements(weighted_elements)

    assert.equal! int_between_calls, [[0, 69]]
    assert.equal! result, 'a'
  end

  RNGTestHelper.with_int_between_stub(rng, result: 19) do |int_between_calls|
    result = rng.random_from_weighted_elements(weighted_elements)

    assert.equal! int_between_calls, [[0, 69]]
    assert.equal! result, 'a'
  end

  RNGTestHelper.with_int_between_stub(rng, result: 20) do |int_between_calls|
    result = rng.random_from_weighted_elements(weighted_elements)

    assert.equal! int_between_calls, [[0, 69]]
    assert.equal! result, 'b'
  end
end

module RNGTestHelper
  def self.with_int_between_stub(rng, result:, &block)
    calls = []
    int_between_stub = lambda { |a, b|
      calls << [a, b]
      result
    }
    with_replaced_method rng, :random_int_between, int_between_stub do
      block.call calls
    end
  end
end
