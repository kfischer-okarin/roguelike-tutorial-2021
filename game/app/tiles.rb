module Tiles
  def self.new_tile(name, char:, fg:, bg:, walkable:)
    @tiles ||= {}
    eval <<-RUBY
      def self.#{name}
        @tiles[#{name.inspect}] ||= build_game_tile char: #{char.inspect}, fg: #{fg.inspect}, bg: #{bg.inspect}, walkable: #{walkable}
      end
    RUBY
  end

  def self.build_game_tile(char:, fg:, bg:, walkable:)
    tile = Engine::Terminal::Tile.new(char, fg: fg, bg: bg)
    GameTile.new(walkable: walkable, tile: tile)
  end

  new_tile :floor, char: ' ', fg: [255, 255, 255], bg: [50, 50, 150], walkable: true
  new_tile :wall, char: ' ', fg: [255, 255, 255], bg: [0, 0, 100], walkable: false
end
