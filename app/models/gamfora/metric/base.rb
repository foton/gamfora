module Gamfora
  module Metric
    #Base stone for counting rewards and scores
    #Each type of metric have separate subclass
    class Base < ApplicationRecord
      self.table_name= 'gamfora_metrics'

      belongs_to :game
      has_many :scores 

      validates :game, presence: true
      validates :name, presence: true

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

    end  
  end
end    
