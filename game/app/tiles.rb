module Tiles
  def self.new_tile(name, char:, fg:, bg:)
    @tiles ||= {}
    eval <<-RUBY
      def self.#{name}
        @tiles[#{name.inspect}] ||= Engine::Terminal::Tile.new(#{char.inspect}, fg: #{fg.inspect}, bg: #{bg.inspect})
      end
    RUBY
  end

  new_tile :floor, char: ' ', fg: [255, 255, 255], bg: [50, 50, 150]
  new_tile :wall, char: ' ', fg: [255, 255, 255], bg: [0, 0, 100]
end
