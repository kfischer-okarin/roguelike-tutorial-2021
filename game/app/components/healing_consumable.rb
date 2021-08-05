module Components
  class HealingConsumable < BaseComponent
    data_accessor :amount

    def activate(consumer)
      consumer.combatant.heal(amount)

      $message_log.add_message(
        text: "You consume the #{entity.name} and recover #{amount} HP!",
        fg: Colors.health_recovered
      )
    end
  end
end
