require 'lib/engine/render_context/rendered_console.rb'

module Engine
  # Simulated terminal for rendering the tiles
  class RenderContext
    attr_accessor :gtk_outputs

    attr_reader :w, :h, :tileset

    def initialize(w, h, tileset:)
      @w = w
      @h = h
      @tileset = tileset

      @prepared = false
      @rendered_console = RenderedConsole.new(@tileset)
    end

    def mouse_coordinates(gtk_inputs)
      mouse = gtk_inputs.mouse
      [mouse.x.idiv(@tileset.tile_w), mouse.y.idiv(@tileset.tile_h)]
    end

    def present(console)
      prepare unless @prepared
      @gtk_outputs.background_color = [0, 0, 0]
      @rendered_console.console = console
      @gtk_outputs.primitives << @rendered_console
    end

    private

    def prepare
      prepare_bg_sprite
      @prepared = true
    end

    def prepare_bg_sprite
      render_target = @gtk_outputs[:bg]
      render_target.width = @tileset.tile_w
      render_target.height = @tileset.tile_h
      render_target.primitives << [0, 0, @tileset.tile_w, @tileset.tile_h, 255, 255, 255].solid
    end
  end
end
