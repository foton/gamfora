require 'test_helper'

module Gamfora
  module Metric
    class PointTest < ActiveSupport::TestCase

      def setup
        @game= gamfora_games(:got)
      end  

      test "can be created" do 
        name="Kingslayer points"
        mt=Gamfora::Metric::Point.new(game: @game, name: name, start_value: 5, min_value: 0, max_value: 10 )
        assert mt.save
        assert_equal @game, mt.game
        assert_equal name, mt.name
        assert_equal({start: 5, min: 0, max: 10}, mt.values)
      end

      test "can be created without MIN and MAX" do 
        mt=Gamfora::Metric::Point.new(game: @game, name: "Kingslayer points", start_value: 5)
        assert mt.save
        assert_equal({start: 5, min: Gamfora::Metric::Base::UNLIMITED, max: Gamfora::Metric::Base::UNLIMITED}, mt.values)
      end

      test "require game" do 
        mt=Gamfora::Metric::Point.new(name: "Kingslayer points", start_value: 0 )
        refute mt.save
        refute mt.errors[:game].empty?
      end

      test "require name" do 
        mt=Gamfora::Metric::Point.new(game: @game, start_value: 0 )
        refute mt.save
        refute mt.errors[:name].empty?
      end

      test "require start value" do 
        mt=Gamfora::Metric::Point.new(game: @game, name: "Kingslayer points" )
        refute mt.save
        refute mt.errors[:values].empty?
      end

      test "validate start value is between min and max" do
        mt=Gamfora::Metric::Point.new(game: @game, name: "Kingslayer points" , start_value: "-1", min_value: "0", max_value: "10")
        refute mt.save
        refute mt.errors[:values].empty?
        assert mt.errors[:values].include?("Hodnota START je menší než hodnota MIN")

        mt=Gamfora::Metric::Point.new(game: @game, name: "Kingslayer points" , start_value: 11, min_value: 0, max_value: 10)
        refute mt.save
        refute mt.errors[:values].empty?
        assert mt.errors[:values].include?("Hodnota START je větší než hodnota MAX")
      end

      test "on create build new scores for each player" do
        skip
      end  
    end  
  end
end      
