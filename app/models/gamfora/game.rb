module Gamfora
  class Game < ApplicationRecord
    belongs_to :owner, class_name: Gamfora.game_owner_class.to_s
    has_many :players, dependent: :destroy
    has_many :metrics, class_name: 'Gamfora::Metric::Any', dependent: :destroy

    validates :name, presence: true
    validates :owner, presence: true


    def owner_name
      owner.send(Gamfora.game_owner_name_attribute)
    end 

    def users
      ([owner]+players.collect {|p| p.user})
    end  

    scope :owned_by, ->(owner) { where(owner_id: owner.id)}
    scope :played_by, ->(user) { where(id: (Gamfora::Player.all_for(user).pluck(:game_id)) )}

  end
end
