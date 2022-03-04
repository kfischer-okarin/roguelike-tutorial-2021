class String # rubocop:disable Style/Documentation
  # The #chars method splits the string into single bytes.
  # This method keeps the UTF-8 characters intact.
  def utf8_chars # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    [].tap { |result|
      original_chars = chars
      index = 0
      while index < original_chars.size
        char = original_chars[index]

        case char.ord
        when 0x00..0x7F
          result << char
          index += 1
        when 0xC0..0xDF
          result << self[index..(index + 1)]
          index += 2
        when 0xE0..0xEF
          result << self[index..(index + 2)]
          index += 3
        else
          result << self[index..(index + 3)]
          index += 4
        end
      end
    }
  end
end
