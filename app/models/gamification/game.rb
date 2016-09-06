module Gamification
  class Game < ApplicationRecord
    validates :name, presence: true
  end
end
