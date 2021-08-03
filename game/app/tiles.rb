module Tiles
  def self.new_tile(name, dark:, light:, walkable:, transparent:)
    @tiles ||= {}
    eval <<-RUBY
      def self.#{name}
        @tiles[#{name.inspect}] ||= build_game_tile dark: #{dark.inspect}, light: #{light.inspect}, walkable: #{walkable}, transparent: #{transparent}
      end
    RUBY
  end

  def self.build_game_tile(dark:, light:, walkable:, transparent:)
    dark = Engine::Tile.new(dark[:char], fg: dark[:fg], bg: dark[:bg])
    light = Engine::Tile.new(light[:char], fg: light[:fg], bg: light[:bg])
    GameTile.new(walkable: walkable, transparent: transparent, dark: dark, light: light)
  end

  new_tile :floor,
           dark: { char: ' ', fg: [255, 255, 255], bg: [50, 50, 150] },
           light: { char: ' ', fg: [255, 255, 255], bg: [200, 180, 50] },
           walkable: true,
           transparent: true
  new_tile :wall,
           dark: { char: ' ', fg: [255, 255, 255], bg: [0, 0, 100] },
           light: { char: ' ', fg: [255, 255, 255], bg: [130, 110, 50] },
           walkable: false,
           transparent: false
end
