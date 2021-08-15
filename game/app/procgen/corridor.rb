module Procgen
  class Corridor
    attr_reader :from, :to

    def initialize(from:, to:)
      @from = from
      @to = to
    end

    def ==(other)
      from == other.from && to == other.to
    end

    def to_s
      "Corridor(#{@from}, #{@to})"
    end

    def inspect
      to_s
    end
  end
end
