class RNG
  attr_reader :seed

  SEED_CHARS = (('0'..'9').to_a + ('A'..'Z').to_a).freeze

  def self.int_seed_from_string_seed(seed)
    seed.chars.reduce(0) { |result, char|
      result * SEED_CHARS.size + SEED_CHARS.index(char)
    }
  end

  def self.new_string_seed
    length = 4 + (rand * 3).floor
    (1..length).map { SEED_CHARS.sample }.join
  end

  def initialize(seed = nil)
    @seed = seed || RNG.new_string_seed
    @random = Random.new RNG.int_seed_from_string_seed(@seed)
  end

  def random_int_between(min, max)
    min + ((max - min + 1) * @random.rand).floor
  end

  def random_position_in_rect(rect)
    [
      random_int_between(rect.x, rect.x + rect.w - 1),
      random_int_between(rect.y, rect.y + rect.h - 1)
    ]
  end

  def rand
    @random.rand
  end

  def random_element_from(collection)
    random_index = (@random.rand * collection.size).floor
    collection[random_index]
  end
end
