module Gamfora
  module Metric
    #Base stone for counting rewards and scores
    #Each type of metric have separate subclass
    class Base < ApplicationRecord
      self.table_name= 'gamfora_metrics'

      belongs_to :game

      validates :game, presence: true
      validates :name, presence: true

      def values
        raise "Should be redefined in subclass to return available values"
      end  

      #add value to current score, with corrections dependent on metrics
      #returns new value(s) for score 
      def add_value(v, score)
      end  

      #set value for current score, with corrections dependent on metrics
      #returns new value(s) for score 
      def set_value(v)
      end  

      #substract value for current score, with corrections dependent on metrics
      #returns new value(s) for score 
      def substract_value(v)
      end  


    end  
  end
end    
