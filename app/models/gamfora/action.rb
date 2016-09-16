module Gamfora
  class Action < ApplicationRecord
    belongs_to :game

    validates :game, presence: true
    validates :key, presence: true, uniqueness: { scope: [:game_id] , message:  ->(object, data) {I18n.t("gamfora.action.errors.key_is_already_used_in_this_game", key: data[:value], game_name: object.game.name)} }    

    def play_by(player)
      #add rewards
      #create event
      "return changed scores"
    end  
  end
end
