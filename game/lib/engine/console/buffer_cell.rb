module Engine
  class Console
    class BufferCell < Array
      # x, y, char, :r, :g, :b, :bg_r, :bg_g, :bg_b, bg_color
      def initialize(console, index)
        super(10)
        self[0] = (index % console.width)
        self[1] = index.idiv(console.width)
      end

      def char
        self[2]
      end

      def char=(char)
        self[2] = char
      end

      def color
        self[3..5]
      end

      def color=(color)
        self[3], self[4], self[5] = color || [nil, nil, nil]
      end

      def background_color
        self[6..8]
      end

      def background_color=(color)
        if color
          self[6], self[7], self[8] = color
          self[9] = true
        else
          self[6] = self[7] = self[8] = nil
          self[9] = false
        end
      end

      def bg_color?
        self[9]
      end

      def self.clear(cell)
        cell[2] = nil
      end
    end
  end
end
