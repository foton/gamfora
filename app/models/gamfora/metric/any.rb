
module Gamfora
  module Metric
    
    #Base stone for counting rewards and scores
    #Each type of metric have separate subclass
    class Any < ApplicationRecord
      self.table_name= 'gamfora_metrics'

      belongs_to :game
      has_many :scores, foreign_key: :metric_id , dependent: :destroy

      validates :game, presence: true
      validates :name, presence: true

      after_create :create_scores_for_players!

      UNLIMITED="unlimited"

      def values
        raise "Should be redefined in subclass to return available values"
      end  

      def is_countable?
        raise "Should be redefined in subclass to return countability"
      end  

      def valid_value_change?(v)
        raise "Should be redefined in subclass to check validity of value inside metric"
      end  

      private
        def create_scores_for_players!
          self.game.players.each do |player|
            Gamfora::Score.create!(player: player, metric: self)
          end
        end  

    end  
  end
end    
