module Scenes
  class ItemSelection < BaseScene
    def initialize(previous_scene, inventory:, &build_action_for_selected_item)
      @inventory = inventory
      @build_action_for_selected_item = build_action_for_selected_item
      super()
      @previous_scene = previous_scene
    end

    protected

    def build_input_handler
      InputEventHandler.new(@inventory, @build_action_for_selected_item)
    end

    def after_action_performed
      $game.scene = @previous_scene
      @previous_scene.after_action_performed
    end

    class InputEventHandler < BaseInputHandler
      def initialize(inventory, build_action_for_selected_item)
        super()
        @inventory = inventory
        @build_action_for_selected_item = build_action_for_selected_item
      end

      def dispatch_action_for_char_typed(event)
        index = event.char.ord - 'a'.ord
        selected_item = @inventory.items[index]
        return unless selected_item

        @build_action_for_selected_item.call(selected_item)
      end
    end
  end
end
