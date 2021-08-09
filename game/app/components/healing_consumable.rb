module Components
  class HealingConsumable < BaseComponent
    data_accessor :amount

    def activate(consumer)
      amount_recovered = consumer.combatant.heal(amount)

      raise Action::Impossible, 'Your health is already full.' unless amount_recovered.positive?

      $message_log.add_message(
        text: "You use the #{entity.name} and recover #{amount_recovered} HP!",
        fg: Colors.health_recovered
      )
      consume
    end

    def consume
      item_container = entity.parent
      item_container.remove_entity entity
    end
  end
end
