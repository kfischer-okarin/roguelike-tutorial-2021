require 'app/components/ai/graph.rb'
require 'app/components/ai/pathfinding.rb'
require 'app/components/ai/enemy.rb'
require 'app/components/ai/none.rb'

module Components
  module AI
    class << self
      def from(entity, data)
        case data.type
        when :enemy
          Components::AI::Enemy.new(entity, data.data)
        else
          Components::AI::None
        end
      end
    end
  end
end
