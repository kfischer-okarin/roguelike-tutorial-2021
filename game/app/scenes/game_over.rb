module Scenes
  class GameOver < BaseScene
    def dispatch_action_for_quit
      EscapeAction
    end
  end
end
