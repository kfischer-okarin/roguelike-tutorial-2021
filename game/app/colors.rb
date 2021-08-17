module Colors
  class << self
    def error
      [255, 64, 64]
    end

    def action_impossible
      [128, 128, 128]
    end

    def health_recovered
      [0, 255, 0]
    end

    def status_effect_applied
      [63, 255, 63]
    end

    def bar_text
      white
    end

    def hp_bar_filled
      [0, 96, 0]
    end

    def hp_bar_empty
      [64, 16, 16]
    end

    def xp_bar_filled
      [96, 96, 0]
    end

    def xp_bar_empty
      [16, 16, 0]
    end

    def welcome_text
      [32, 160, 255]
    end

    def player_attack
      [224, 224, 224]
    end

    def enemy_attack
      [255, 192, 192]
    end

    def player_death
      [255, 48, 48]
    end

    def enemy_death
      [255, 160, 48]
    end

    def white
      [255, 255, 255]
    end

    def black
      [0, 0, 0]
    end

    def item_window_bg
      black
    end

    def item_window_fg
      white
    end

    def item_window_selected
      [128, 128, 0]
    end

    def menu_title
      [63, 255, 63]
    end

    def menu_text
      white
    end

    def enter_portal
      [159, 63, 255]
    end
  end
end
