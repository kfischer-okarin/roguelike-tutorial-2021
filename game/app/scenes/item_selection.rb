module Scenes
  class ItemSelection < BaseScene
    def initialize(previous_scene, inventory:, title: nil, window_x: 0, &build_action_for_selected_item)
      @inventory = inventory
      @build_action_for_selected_item = build_action_for_selected_item
      @previous_scene = previous_scene
      @item_list = UI::ItemList.new(
        @inventory,
        top: 44, x: window_x,
        title: title || 'Select item'
      )
      super()
    end

    def render(console)
      @previous_scene.render(console)
      @item_list.render(console)
    end

    def action_for_item(item)
      @build_action_for_selected_item.call(item)
    end

    def after_action_performed
      $game.pop_scene
      @previous_scene.after_action_performed
    end

    protected

    def build_input_handler
      InputEventHandler.new(@item_list, self)
    end

    class InputEventHandler < BaseInputHandler
      def initialize(selection_ui, selection_scene)
        super()
        @selection_ui = selection_ui
        @selection_scene = selection_scene
      end

      def dispatch_action_for_char_typed(event)
        return $game.show_help('Item Selection') if event.char == '?'
        return $game.pop_scene unless @selection_ui.valid_input_char? event.char

        selected_item = @selection_ui.item_for_char event.char
        return unless selected_item

        @selection_scene.action_for_item selected_item
      end

      def dispatch_action_for_click
        selected_item = @selection_ui.mouse_over_item
        return unless selected_item

        @selection_scene.action_for_item selected_item
      end

      def dispatch_action_for_quit
        $game.pop_scene
      end
    end
  end
end
