module Scenes
  class GameOver < BaseScene
    def dispatch_action_for_quit
      $gtk.reset seed: Time.now.to_i
    end
  end
end
