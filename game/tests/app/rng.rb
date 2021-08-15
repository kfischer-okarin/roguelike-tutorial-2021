require 'tests/test_helper.rb'

def test_rng_int_seed_from_string_seed(_args, assert)
  # 36 digit system like hexadecimal
  assert.equal! RNG.int_seed_from_string_seed('CBA3'), 3 + 10 * 36 + 11 * 36**2 + 12 * 36**3
end
