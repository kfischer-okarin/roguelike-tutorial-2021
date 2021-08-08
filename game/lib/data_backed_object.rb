class DataBackedObject
  class << self
    def data_reader(*attributes)
      attributes.each do |attribute|
        define_method attribute do
          data.send(attribute)
        end
      end
    end

    def data_writer(*attributes)
      attributes.each do |attribute|
        method = :"#{attribute}="
        define_method method do |value|
          data.send(method, value)
        end
      end
    end

    def data_accessor(*attributes)
      data_reader(*attributes)
      data_writer(*attributes)
    end
  end

  def to_s
    "#{self.class}(#{data.inspect})"
  end

  def inspect
    to_s
  end

  def serialize
    data
  end
end
