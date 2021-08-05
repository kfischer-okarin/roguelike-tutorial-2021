module GTK
  class Assert
    def includes!(collection, element, message = nil)
      @assertion_performed = true
      return if collection.include? element

      raise "Collection:\n  #{collection.inspect}\n\ndid not contain:\n  #{element}\n#{message}."
    end

    def raises_with_message!(exception_class, exception_message, message = nil)
      @assertion_performed = true

      expected_description = "#{exception_class} with #{exception_message.inspect}"
      begin
        yield
        raise "Expected:\n  #{expected_description}\n\nto be raised, but nothing was raised.\n #{message}."
      rescue exception_class => e
        return if e.message == exception_message

        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      rescue StandardError => e
        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      end
    end

    def raises_no_exception!(message = nil)
      @assertion_performed = true

      begin
        yield
      rescue StandardError => e
        raise "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected none to be raised.\n#{message}."
      end
    end

    private

    def exception_description(exception)
      "#{exception.class} with #{exception.message.inspect}"
    end
  end
end

module TestHelper
  class << self
    def init_globals
      $message_log = MessageLog.new
    end

    def log_messages
      $message_log.messages.map(&:text)
    end

    def stub(methods)
      Object.new.tap { |result|
        methods.each do |method_name, return_value|
          result.define_singleton_method method_name do |*args|
            return_value&.call(*args) || return_value
          end
        end
      }
    end

    def build_map(width, height)
      GameMap.new(width: width, height: height, entities: []).tap { |game_map|
        game_map.fill_rect([0, 0, width, height], Tiles.floor)
      }
    end

    def build_map_with_entities(entities_by_position)
      width = entities_by_position.keys.map(&:x).max + 3
      height = entities_by_position.keys.map(&:y).max + 3
      build_map(width, height).tap { |game_map|
        entities_by_position.each do |position, entity|
          entity.place(game_map, x: position.x, y: position.y)
        end
      }
    end

    def build_entity(name = nil)
      Entity::BaseEntity.new(
        :entity,
        x: nil, y: nil,
        name: name || 'An entity'
      )
    end

    def build_combatant(name = nil, hp: 20, power: 5, defense: 5)
      Entity::Actor.new(
        :combatant,
        x: nil, y: nil,
        name: name || 'Enemy',
        combatant: { hp: hp, max_hp: hp, defense: defense, power: power }
      )
    end
  end
end
