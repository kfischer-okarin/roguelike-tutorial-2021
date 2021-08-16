module Components
  class Level < BaseComponent
    data_accessor :level_up_base, :level_up_factor, :current_level, :current_xp

    def initialize(parent, data)
      super
      self.current_level ||= 1
      self.current_xp ||= 0
    end

    def experience_to_next_level
      level_up_base + current_level * level_up_factor
    end

    def requires_level_up?
      current_xp >= experience_to_next_level
    end

    def add_xp(amount)
      self.current_xp += amount
      $message_log.add_message(text: "You gain #{amount} experience points.")
      return unless requires_level_up?

      $message_log.add_message(text: "You advance to level #{current_level + 1}!")
    end

    def increase_level
      self.current_xp -= experience_to_next_level
      self.current_level += 1
    end
  end
end
