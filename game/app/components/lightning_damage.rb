module Components
  class LightningDamage < Consumable
    data_accessor :amount, :maximum_range

    def activate(consumer)
      target = visible_other_actors(consumer).min_by { |actor| GTK::Geometry.distance(consumer, actor) }
      if !target || GTK::Geometry.distance(consumer, target) > maximum_range
        raise Action::Impossible, 'No enemy is close enough to strike.'
      end

      target.combatant.take_damage(amount)
      $message_log.add_message(text: "A lightning bolt strikes the #{target.name} with a loud thunder, for #{amount} damage!")
      consume
    end

    def visible_other_actors(consumer)
      game_map = entity.game_map
      game_map.actors.select { |actor|
        actor != consumer && game_map.visible?(actor.x, actor.y)
      }
    end
  end
end
