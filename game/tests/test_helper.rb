module GTK
  class Assert
    def includes!(collection, element, message = nil)
      @assertion_performed = true
      return if collection.include? element

      raise "Collection:\n  #{collection.inspect}\n\ndid not contain:\n  #{element}\n#{message}."
    end

    def includes_no!(collection, element, message = nil)
      @assertion_performed = true
      return unless collection.include? element

      raise "Collection:\n  #{collection.inspect}\n\nwas not expected to contain:\n  #{element}\n#{message}."
    end

    def has_attributes!(object, attributes)
      @assertion_performed = true
      missing_attributes = attributes.each_key.reject { |name| object.respond_to?(name) }

      expectation_message = "Object:\n  #{object}\n\nwas expected to have attributes:\n  #{attributes.inspect}\n\n"
      raise "#{expectation_message}but it didn't respond to:\n  #{missing_attributes}" unless missing_attributes.empty?

      actual_values = attributes.each_key.map { |name| [name, object.send(name)] }.to_h
      return if actual_values == attributes

      raise "#{expectation_message}but it's actual attributes were:\n  #{actual_values}"
    end

    def raises_with_message!(exception_class, exception_message, message = nil)
      @assertion_performed = true

      expected_description = "#{exception_class} with #{exception_message.inspect}"
      error_message = nil
      begin
        yield
        error_message = "Expected:\n  #{expected_description}\n\nto be raised, but nothing was raised.\n #{message}."
      rescue exception_class => e
        return if e.message == exception_message

        error_message = "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      rescue StandardError => e
        error_message = "Actual exception:\n  #{exception_description(e)}\n\nwas raised but expected:\n  #{expected_description}\n#{message}."
      end

      raise error_message if error_message
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
    def init_globals(args)
      $message_log = MessageLog.new
      Entities.setup args.state
      GTK::Entity.strict_entities.clear
    end

    def log_messages
      $message_log.messages.map(&:text)
    end

    def stub(methods)
      Object.new.tap { |result|
        methods.each do |method_name, return_value|
          result.define_singleton_method method_name do |*args|
            return return_value.call(*args) if return_value.respond_to? :call

            return_value
          end
        end
      }
    end

    def allow_calls(name, allowed_calls)
      index = 0
      lambda { |*args|
        expected_args, result = allowed_calls[index]
        unless args == expected_args
          raise "Expected call \##{index + 1} to #{name} to be with args:\n  #{expected_args}\n\n but it was called with:\n  #{args}"
        end
        index += 1
        result
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
      Entity.build(
        :entity,
        x: nil, y: nil,
        name: name || 'An entity'
      )
    end

    def build_actor(name = nil, hp: 20, power: 5, defense: 5)
      Entity.build(
        :combatant,
        x: nil, y: nil,
        name: name || 'Enemy',
        combatant: { hp: hp, max_hp: hp, defense: defense, power: power }
      )
    end
  end

  class Spy
    def initialize
      @calls = []
    end

    def method_missing(name, *args)
      @calls << [name, args]
    end
  end
end
