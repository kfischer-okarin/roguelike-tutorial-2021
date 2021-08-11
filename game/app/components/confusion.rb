module Components
  class Confusion < Consumable
    data_reader :turns

    def activate(_consumer, target)
      $message_log.add_message(
        text: "The eyes of the #{target.name} look vacant, as it starts to stumble around!",
        fg: Colors.status_effect_applied
      )
      target.replace_ai type: :confused, data: { turns: turns, previous_ai: target.data.ai }
      consume
    end
  end
end
