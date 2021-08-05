require 'tests/test_helper.rb'

def test_base_scene_log_impossible_actions(_args, assert)
  TestHelper.init_globals
  scene = TestHelper.build_test_scene
  scene.next_action = -> { raise Action::Impossible, 'Something did not work.' }

  scene.handle_input_events [{ type: :test }]

  assert.includes! TestHelper.log_messages, 'Something did not work.'
end

module TestHelper
  class << self
    def build_test_scene
      scene_class = Class.new(Scenes::BaseScene) do
        def input_event_handler
          @input_event_handler
        end

        def next_action=(action_lambda)
          @input_event_handler = TestHelper.stub(
            handle_input_event: ->(_) { TestHelper.stub(perform: action_lambda) }
          )
        end
      end

      scene_class.new
    end
  end
end
