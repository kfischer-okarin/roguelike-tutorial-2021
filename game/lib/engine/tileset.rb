module Engine
  # Tileset in 16x16 tiles Dwarf Fortress layout
  class Tileset
    attr_reader :path, :tile_w, :tile_h

    def initialize(path)
      @path = path
      calc_tile_dimensions
    end

    TILE_POSITIONS = {
      '@' => [0, 11].freeze,
      'B' => [2, 11].freeze,
      's' => [3, 8].freeze,
      '%' => [5, 13].freeze
    }.freeze

    def tile_x(string)
      TILE_POSITIONS[string].x * @tile_w
    end

    def tile_y(string)
      TILE_POSITIONS[string].y * @tile_h
    end

    private

    def calc_tile_dimensions
      w, h = $gtk.calcspritebox @path
      @tile_w = w.idiv(16)
      @tile_h = h.idiv(16)
    end
  end
end
