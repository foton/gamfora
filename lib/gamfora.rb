require "gamfora/engine"

require "haml"
require "rails-i18n"

module Gamfora
  mattr_accessor :game_owner_class
  mattr_accessor :game_owner_name_attribute
  mattr_accessor :player_class
  mattr_accessor :player_name_attribute

  def self.game_owner_class
    @@game_owner_class.constantize
  end

  def self.player_class
    @@player_class.constantize
  end

end
