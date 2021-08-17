module Scenes
  class ItemSelection < BaseScene
    def initialize(inventory:, title: nil, window_x: 0, &build_action_for_selected_item)
      @inventory = inventory
      @build_action_for_selected_item = build_action_for_selected_item
      @title = title || 'Select item'
      @window_x = window_x
      @window_h = [@inventory.items.size + 2, 3].max
      @window_w = @title.size + 4
      @window_top = 44
      @item_choice = UI::Choice.new(
        choices: @inventory.items.map(&:name),
        x: @window_x + 1, top: @window_top - 1, w: @window_w - 2
      )
      super()
    end

    def render(console)
      console.draw_frame(
        x: @window_x, y: @window_top - @window_h + 1, width: @window_w, height: @window_h,
        title: @title,
        fg: Colors.item_window_fg, bg: Colors.item_window_bg
      )
      @item_choice.render(console)
    end

    def action_for_item(item)
      @build_action_for_selected_item.call(item).tap { |action|
        pop_scene if action&.respond_to? :perform
      }
    end

    def dispatch_action_for_char_typed(event)
      return $game.show_help('Item Selection') if event.char == '?'

      selected_item_index = @item_choice.choice_index_for_char_typed_event(event)
      return pop_scene unless selected_item_index

      action_for_item @inventory.items[selected_item_index]
    end

    def dispatch_action_for_click
      selected_item_index = @item_choice.mouse_over_index
      return unless selected_item_index

      action_for_item @inventory.items[selected_item_index]
    end

    def dispatch_action_for_quit
      pop_scene
    end
  end
end
