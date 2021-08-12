module Scenes
  class Gameplay < BaseScene
    class InputEventHandler < BaseInputHandler
      attr_reader :player

      def initialize(player:)
        super()
        @player = player
      end

      def dispatch_action_for_quit
        EscapeAction
      end

      def dispatch_action_for_up
        BumpIntoEntityAction.new(player, dx: 0, dy: 1)
      end

      def dispatch_action_for_down
        BumpIntoEntityAction.new(player, dx: 0, dy: -1)
      end

      def dispatch_action_for_left
        BumpIntoEntityAction.new(player, dx: -1, dy: 0)
      end

      def dispatch_action_for_right
        BumpIntoEntityAction.new(player, dx: 1, dy: 0)
      end

      def dispatch_action_for_up_right
        BumpIntoEntityAction.new(player, dx: 1, dy: 1)
      end

      def dispatch_action_for_up_left
        BumpIntoEntityAction.new(player, dx: -1, dy: 1)
      end

      def dispatch_action_for_down_right
        BumpIntoEntityAction.new(player, dx: 1, dy: -1)
      end

      def dispatch_action_for_down_left
        BumpIntoEntityAction.new(player, dx: -1, dy: -1)
      end

      def dispatch_action_for_get
        PickupAction.new(player)
      end

      def dispatch_action_for_wait
        WaitAction
      end

      def dispatch_action_for_view_history
        $game.show_history($console)
        nil
      end

      def dispatch_action_for_inventory
        $game.show_inventory
        nil
      end

      def dispatch_action_for_drop
        $game.show_drop_item_menu
        nil
      end

      def dispatch_action_for_look
        $game.start_look
        nil
      end

      def dispatch_action_for_help
        $game.show_help('Gameplay')
        nil
      end
    end
  end
end
