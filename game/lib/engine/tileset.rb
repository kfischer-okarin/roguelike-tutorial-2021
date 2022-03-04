require 'lib/builtin_extensions/string_utf8_chars.rb'

module Engine
  # Dwarf Fortress style tileset.
  # Using the characters from the IBM Code Page 437 laid out in a 16x16 grid.
  class Tileset
    attr_reader :path, :tile_w, :tile_h

    def initialize(path)
      @tile_indexes = build_tile_indexes
      @path = path
      calc_tile_dimensions
    end

    def row_count
      16
    end

    def tiles_per_row
      16
    end

    def tile_index(char)
      @tile_indexes[char]
    end

    def self.tiles_from_string(string)
      string.utf8_chars
    end

    private

    def calc_tile_dimensions
      w, h = $gtk.calcspritebox @path
      @tile_w = w.idiv(tiles_per_row)
      @tile_h = h.idiv(row_count)
    end

    def layout
      <<~CHARS.freeze
        �☺☻♥♦♣♠•◘○◙♂♀♪♫☼
        ►◄↕‼¶§▬↨↑↓→←∟↔▲▼
         !"#$%&'()*+,-./
        0123456789:;<=>?
        @ABCDEFGHIJKLMNO
        PQRSTUVWXYZ[\\]^_
        `abcdefghijklmno
        pqrstuvwxyz{|}~⌂
        ÇüéâäàåçêëèïîìÄÅ
        ÉæÆôöòûùÿÖÜ¢£¥₧ƒ
        áíóúñÑªº¿⌐¬½¼¡«»
        ░▒▓│┤╡╢╖╕╣║╗╝╜╛┐
        └┴┬├─┼╞╟╚╔╩╦╠═╬╧
        ╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀
        αßΓπΣσµτΦΘΩδ∞φε∩
        ≡±≥≤⌠⌡÷≈°∙·√ⁿ²■�
      CHARS
    end

    # Map of tiles to their index in the layout.
    # Index is enumerated row by row from bottom left to top right.
    def build_tile_indexes
      {}.tap { |result|
        lines = layout.split("\n")
        lines.each_with_index { |line, y_from_top|
          Tileset.tiles_from_string(line).each_with_index do |char, x|
            result[char] = ((row_count - y_from_top - 1) * tiles_per_row) + x
          end
        }
      }.freeze
    end
  end
end
