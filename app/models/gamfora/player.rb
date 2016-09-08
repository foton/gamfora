module Gamfora
  class Player < ApplicationRecord
    belongs_to :game
    #for internal use, we name :player_person from main map as 'user', but it can be anything
    belongs_to :user ,class_name: Gamfora.player_class.to_s
    default_scope { includes(:user) }

    validates :game, presence: true
    validates :user, presence: true

    
    def user_id=(v)
      write_attribute(Gamfora::Player.user_ref_column_name, v)
    end
    
    def user_id
      read_attribute(Gamfora::Player.user_ref_column_name)
    end  

    def self.user_ref_column_name
      "#{Gamfora.player_class.to_s.downcase}_id"
    end

    def name
      user.send(Gamfora.player_name_attribute)
    end  
      
    scope :all_for, ->(user) { where( Gamfora::Player.user_ref_column_name => user.id)}
  end
end
