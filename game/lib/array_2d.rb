class Array2D
  attr_reader :data, :w, :h

  def initialize(data, w:, h:)
    @data = data
    @w = w
    @h = h
  end

  def [](x, y)
    @data[y * @w + x]
  end
end
