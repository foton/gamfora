require "gamification/engine"

require "haml"
module Gamification
  mattr_accessor :game_owner_class
  mattr_accessor :player_class

  def self.game_owner_class
    @@game_owner_class.constantize
  end

  def self.player_class
    @@player_class.constantize
  end

end
