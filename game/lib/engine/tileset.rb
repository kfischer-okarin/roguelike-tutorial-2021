class String
  def unicode_chars
    [].tap { |result|
      original_chars = chars
      index = 0
      while index < original_chars.size
        char = original_chars[index]
        if char == "\xe2"
          result << self[index..(index + 2)]
          index += 3
        else
          result << char
          index += 1
        end
      end
    }
  end
end

module Engine
  # Tileset in 16x16 tiles Dwarf Fortress layout
  class Tileset
    attr_reader :path, :tile_w, :tile_h

    def initialize(path)
      @path = path
      calc_tile_dimensions
    end

    def tiles_per_row
      TILES_PER_ROW
    end

    def row_count
      ROW_COUNT
    end

    TILES_PER_ROW = 16
    ROW_COUNT = 16

    TILES = [
      [].freeze,
      [].freeze,
      %( !"#$%&'()*+,-./).chars.freeze,
      '0123456789:;<=>?'.chars.freeze,
      '@ABCDEFGHIJKLMNO'.chars.freeze,
      'PQRSTUVWXYZ[\]^_'.chars.freeze,
      '`abcdefghijklmno'.chars.freeze,
      'pqrstuvwxyz{|}~⌂'.chars.freeze,
      [].freeze,
      [].freeze,
      [].freeze,
      '░▒▓│┤╡╢╖╕╣║╗╝╜╛┐'.unicode_chars.freeze,
      '└┴┬├─┼╞╟╚╔╩╦╠═╬╧'.unicode_chars.freeze,
      '╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀'.unicode_chars.freeze
    ].freeze

    TILE_INDEXES = {}.tap { |result|
      TILES.each_with_index { |row, y_from_top|
        row.each_with_index do |char, x|
          result[char] = ((ROW_COUNT - y_from_top - 1) * TILES_PER_ROW) + x
        end
      }
    }.freeze

    def tile_index(string)
      TILE_INDEXES[string]
    end

    private

    def calc_tile_dimensions
      w, h = $gtk.calcspritebox @path
      @tile_w = w.idiv(TILES_PER_ROW)
      @tile_h = h.idiv(ROW_COUNT)
    end
  end
end
