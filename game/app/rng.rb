class RNG
  attr_reader :seed

  def initialize(seed = nil)
    @seed = seed
    @random = Random.new(seed)
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
