class DataBackedObject
  def self.data_reader(*attributes)
    attributes.each do |attribute|
      define_method attribute do
        data.send(attribute)
      end
    end
  end

  def self.data_writer(*attributes)
    attributes.each do |attribute|
      method = :"#{attribute}="
      define_method method do |value|
        data.send(method, value)
      end
    end
  end

  def self.data_accessor(*attributes)
    data_reader(*attributes)
    data_writer(*attributes)
  end
end
