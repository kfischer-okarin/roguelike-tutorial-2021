module ScreenLayout
  class << self
    def map_offset
      [0, 5]
    end

    def map_to_console_position(map_position)
      offset_x, offset_y = map_offset
      [map_position.x + offset_x, map_position.y + offset_y]
    end

    def console_to_map_position(console_position)
      offset_x, offset_y = map_offset
      [console_position.x - offset_x, console_position.y - offset_y]
    end
  end
end
