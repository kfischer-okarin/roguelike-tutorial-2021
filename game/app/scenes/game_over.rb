module Scenes
  class GameOver < BaseScene
    def dispatch_action_for_quit
      $game.quit
    end
  end
end
