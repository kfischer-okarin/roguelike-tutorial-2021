module Procgen
  class Generator
    attr_writer :rng

    def rng
      @rng ||= RNG.new
    end
  end
end
