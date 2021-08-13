module Components
  class Confusion < Consumable
    data_reader :turns

    def get_action(consumer)
      $game.select_target_position do |position|
        UseItemOnPositionAction.new(consumer, entity, position: position)
      end
    end

    def activate(consumer, position)
      raise Action::Impossible, 'You cannot target an area that you cannot see.' unless position_visible? position

      target = game_map.actor_at(position.x, position.y)
      raise Action::Impossible, 'You must select an enemy to target.' unless target
      raise Action::Impossible, 'You cannot confuse yourself!' if target == consumer

      $message_log.add_message(
        text: "The eyes of the #{target.name} look vacant, as it starts to stumble around!",
        fg: Colors.status_effect_applied
      )
      target.replace_ai type: :confused, data: { turns: turns, previous_ai: target.data.ai }
      consume
    end

    def position_visible?(position)
      game_map.visible? position.x, position.y
    end
  end
end
