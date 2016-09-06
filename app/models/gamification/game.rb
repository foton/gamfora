module Gamification
  class Game < ApplicationRecord
    belongs_to :owner, class_name: Gamification.game_owner_class.to_s

    validates :name, presence: true
    validates :owner, presence: true

    scope :owned_by, ->(owner) { where(owner_id: owner.id)}
  end
end
