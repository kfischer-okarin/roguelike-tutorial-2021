module Engine
  # Tileset in 16x16 tiles Dwarf Fortress layout
  class Tileset
    attr_reader :path, :tile_w, :tile_h

    def initialize(path)
      @path = path
      calc_tile_dimensions
    end

    def tile_x(_string)
      0 # Hardcoded for @
    end

    def tile_y(_string)
      @tile_h * 11 # Hardcoded for @
    end

    private

    def calc_tile_dimensions
      w, h = $gtk.calcspritebox @path
      @tile_w = w.idiv(16)
      @tile_h = h.idiv(16)
    end
  end
end
