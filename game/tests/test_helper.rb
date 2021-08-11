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

      raise "#{collection_description(collection)}was not expected to contain exactly:\n  #{element}\n#{message}."
    end

    def contains_exactly!(collection, elements, message = nil)
      @assertion_performed = true
      expected_description = "#{collection_description(collection)}was expected to contain exactly:\n#{elements.inspect}\n\n"
      missing_elements = elements.reject { |element| collection.include? element }
      unless missing_elements.empty?
        raise "#{expected_description}but it was was missing:\n#{missing_elements.inspect}\n#{message}"
      end

      unexpected_elements = collection.reject { |element| elements.include? element }
      return if unexpected_elements.empty?

      raise "#{expected_description}but it additionally contained:\n#{unexpected_elements.inspect}\n#{message}"
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

    def collection_description(collection)
      "Collection:\n  #{collection.inspect}\n\n"
    end
  end
end

module TestHelper
  class Spy
    attr_reader :calls

    def initialize(wrapped_object = nil)
      @wrapped_object = wrapped_object
      @calls = []
    end

    def method_missing(name, *args)
      @calls << [name, args]
      @wrapped_object.send(name, *args) if @wrapped_object && @wrapped_object.respond_to?(name)
    end
  end

  class Mock
    def initialize
      @defined_methods = []
      @expected_calls = []
      @index = 0
    end

    def expect_call(method_name, args: nil, return_value: nil)
      define_mock_method method_name unless @defined_methods.include? method_name
      @expected_calls << [method_name, args || [], return_value]
    end

    def define_mock_method(name)
      define_singleton_method name do |*args|
        actual_call = "#{name} was called with args:\n#{args}\n\n"
        raise "#{actual_call} as call \##{@index + 1} but no more calls are expected." unless @index < @expected_calls.size

        expected_name, expected_args, return_value = expected_call
        if name == expected_name && args == expected_args
          @index += 1
          return return_value
        end

        raise "#{expected_call_description} but actually #{actual_call}"
      end
      @defined_methods << name
    end

    def expected_call
      @expected_calls[@index]
    end

    def expected_call_description
      expected_name, expected_args = expected_call[0..1]
      "Expected call \##{@index + 1} to be to #{expected_name} with args:\n  #{expected_args}\n\n"
    end

    def assert_all_calls_received!(assert)
      assert.ok!
      return if @index == @expected_calls.size

      raise "#{expected_call_description} but it was never received."
    end
  end
end

def log_messages
  $message_log.messages.map(&:text)
end

def build_entity(attributes = nil)
  values = attributes || {}
  final_attributes = {
    x: nil, y: nil, parent: nil,
    color: [255, 255, 255],
    render_order: RenderOrder::ACTOR,
    blocks_movement: true,
    name: values.delete(:name) || 'Entity'
  }
  final_attributes[:char] ||= final_attributes[:name][0]
  final_attributes.update(values)
  Entity.build(
    final_attributes[:name].to_sym,
    final_attributes
  )
end

def build_actor(attributes = nil)
  values = attributes || {}
  final_attributes = {
    name: values.delete(:name) || 'Monster',
    combatant: {
      hp: values.delete(:hp) || 20,
      defense: values.delete(:defense) || 5,
      power: values.delete(:power) || 5
    },
    inventory: { items: [] },
    ai: { type: :enemy, data: {} }
  }
  final_attributes[:combatant][:max_hp] = values.delete(:max_hp) || final_attributes[:combatant][:hp]
  final_attributes.update(values)
  build_entity(final_attributes).tap { |result|
    (values[:items] || []).each do |item|
      item.place(result.inventory)
    end
  }
end

def build_player
  EntityPrototypes.build(:player)
end

def build_item(attributes = nil)
  values = attributes || {}
  final_attributes = {
    name: values.delete(:name) || 'Item',
    blocks_movement: false,
    consumable: values.empty? ? { type: :healing, amount: 5 } : values
  }
  build_entity(final_attributes)
end

def build_game_map(width = 10, height = 10)
  GameMap.new(width: width, height: height, entities: []).tap { |game_map|
    game_map.fill_rect([0, 0, width, height], Tiles.floor)
    game_map.define_singleton_method :visible? do |_x, _y|
      true
    end
  }
end

def build_game_map_with_entities(entities_by_position)
  width = entities_by_position.keys.map(&:x).max + 3
  height = entities_by_position.keys.map(&:y).max + 3
  build_game_map(width, height).tap { |game_map|
    entities_by_position.each do |position, entity|
      entity.place(game_map, x: position.x, y: position.y)
    end
  }
end

def make_positions_non_visible(game_map, positions)
  original_method = game_map.method(:visible?)
  game_map.define_singleton_method :visible? do |x, y|
    return false if positions.include? [x, y]

    original_method.call(x, y)
  end
end

def replace_method(object, name, &implementation)
  object.define_singleton_method(name, &implementation)
end

def stub_attribute(object, attribute, value)
  replace_method(object, attribute) { value }
end

def stub_attribute_with_mock(object, attribute)
  stub_attribute object, attribute, TestHelper::Spy.new
end

def mock_method(object, name)
  [].tap { |calls|
    replace_method(object, name) { |*args| calls << args }
  }
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

$before_each_blocks = []

def before_each(&block)
  $before_each_blocks << block
end

module TestExtension
  def start
    (test_methods + test_methods_focused).each do |method_name|
      old_method = method(method_name)
      define_singleton_method method_name do |args, assert|
        $before_each_blocks.each do |before_each_block|
          before_each_block.call(args, assert)
        end
        old_method.call(args, assert)
      end
    end

    super
  end
end

GTK::Tests.prepend TestExtension

before_each do |args|
  GTK::Entity.strict_entities.clear
  Entities.setup args.state
  Entities.player = build_player
  $message_log = MessageLog.new
  $game = Game.new(player: Entities.player, scene: :initial_scene)
end
