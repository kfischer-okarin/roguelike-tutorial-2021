class Array2D
  attr_reader :data, :w, :h

  def initialize(w, h, data = nil, &block)
    @data = data || Array.new(w * h, &block)
    @w = w
    @h = h
  end

  def [](x, y)
    return nil unless in_bounds?(x, y)

    @data[y * @w + x]
  end

  def []=(x, y, value)
    return unless in_bounds?(x, y)

    case value
    when Array2D
      assign_array_2d(x, y, value)
    else
      @data[y * @w + x] = value
    end
  end

  def fill_rect(rect, value)
    x = rect.x
    y = rect.y
    assigned_index = 0
    assigned_w = rect.w
    assigned_size = rect.w * rect.h

    own_data = @data
    own_w = @w
    own_index = y * own_w + x
    next_row_index = own_index + assigned_w

    while assigned_index < assigned_size
      own_data[own_index] = value
      assigned_index += 1
      own_index += 1
      if own_index >= next_row_index
        own_index = own_index - assigned_w + own_w
        next_row_index += own_w
      end
    end
  end

  def fill(value)
    @data.fill(value)
  end

  private

  def in_bounds?(x, y)
    x >= 0 && x < @w && y >= 0 && y < @h
  end

  def assign_array_2d(x, y, array_2d)
    assigned_index = 0
    assigned_data = array_2d.data
    assigned_size = assigned_data.size
    assigned_w = array_2d.w

    own_data = @data
    own_w = @w
    own_index = y * own_w + x
    next_row_index = own_index + assigned_w

    while assigned_index < assigned_size
      own_data[own_index] = assigned_data[assigned_index]
      assigned_index += 1
      own_index += 1
      if own_index >= next_row_index
        own_index = own_index - assigned_w + own_w
        next_row_index += own_w
      end
    end
  end

  class AttributeAccessor
    def initialize(array_2d, attribute)
      @array_2d = array_2d
      @attribute = attribute
    end

    def [](x, y)
      @array_2d[x, y].send(@attribute)
    end

    def []=(x, y, value)
      @array_2d[x, y].send(:"#{@attribute}=", value)
    end
  end
end
