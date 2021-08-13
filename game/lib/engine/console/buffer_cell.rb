module Engine
  class Console
    class BufferCell < Array
      # x, y, char, :r, :g, :b, :a, :bg_r, :bg_g, :bg_b, :bg_a, bg_color
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
        self[3..6]
      end

      def color=(color)
        self[3], self[4], self[5], self[6] = color || [nil, nil, nil, nil]
      end

      def background_color
        self[7..10]
      end

      def background_color=(color)
        if color
          self[7], self[8], self[9], self[10] = color
          self[11] = true
        else
          self[7] = self[8] = self[9] = self[10] = nil
          self[11] = false
        end
      end

      def bg_color?
        self[11]
      end

      def self.clear(cell)
        cell[2] = nil
      end
    end
  end
end
