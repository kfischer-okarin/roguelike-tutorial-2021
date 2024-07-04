module Components
  module AI
    class Enemy < BaseComponent
      def perform_action
        target = $game.player
        dy = target.y - entity.y
        dx = target.x - entity.x
        distance = [dx.abs, dy.abs].max

        if entity.game_map.visible?(entity.x, entity.y)
          return MeleeAction.new(entity, dx: dx, dy: dy).perform if distance <= 1

          data.path = path_to(target.x, target.y)
        end

        if data.path && !data.path.empty?
          dest_x, dest_y = data.path.shift
          return MovementAction.new(entity, dx: dest_x - entity.x, dy: dest_y - entity.y).perform
        end

        WaitAction.perform
      end

      private

      def path_to(x, y)
        graph = Graph.new(entity.game_map)
        path_finding = Pathfinding.new(graph, from: [entity.x, entity.y], to: [x, y])
        path_finding.path
      end
    end
  end
end
