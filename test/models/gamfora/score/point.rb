require 'test_helper'

module Gamfora
  module Score
    class PointTest < ActiveSupport::TestCase

      def setup
        @game= gamfora_games(:got)
      end  

      test "do not go below minimum if min_value is set" do 
        skip #mt=Gamfora::Metric::Point.new(game: @game, name: "Kingslayer points", start_value: 0 )

      end

      test "do not go over maximum if max_value is set" do 
        skip
      end
      
     
    end  
  end
end      
