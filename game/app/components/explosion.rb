module Components
  class Explosion < Consumable
    data_reader :damage, :radius

    def activate(_consumer, center)
      raise Action::Impossible, 'You cannot target an area that you cannot see.' unless position_visible? center

      target_positions = game_map.positions_in_radius(center: center, radius: radius)
      target_positions << center
      targets = game_map.actors.select { |actor|
        target_positions.include? [actor.x, actor.y]
      }
      raise Action::Impossible, 'There are no targets in the radius.' if targets.empty?

      targets.each do |target|
        $message_log.add_message(
          text: "The #{target.name} is engulfed in a fiery explosion, taking #{damage} damage!"
        )
        target.combatant.take_damage(damage)
      end
      consume
    end

    def position_visible?(position)
      game_map.visible? position.x, position.y
    end
  end
end
