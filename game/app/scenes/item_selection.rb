module Scenes
  class ItemSelection < BaseScene
    def initialize(inventory:, title: nil, window_x: 0, &build_action_for_selected_item)
      @inventory = inventory
      @build_action_for_selected_item = build_action_for_selected_item
      @item_list = UI::ItemList.new(
        @inventory,
        top: 44, x: window_x,
        title: title || 'Select item'
      )
      super()
    end

    def render(console)
      @item_list.render(console)
    end

    def action_for_item(item)
      @build_action_for_selected_item.call(item).tap { |action|
        pop_scene if action&.respond_to? :perform
      }
    end

    def dispatch_action_for_char_typed(event)
      return $game.show_help('Item Selection') if event.char == '?'
      return pop_scene unless @item_list.valid_input_char? event.char

      selected_item = @item_list.item_for_char event.char
      return unless selected_item

      action_for_item selected_item
    end

    def dispatch_action_for_click
      selected_item = @item_list.mouse_over_item
      return unless selected_item

      action_for_item selected_item
    end

    def dispatch_action_for_quit
      pop_scene
    end
  end
end
