require 'test_helper'

module Gamfora
  class ScoreTest < ActiveSupport::TestCase

    def setup
      @game= gamfora_games(:got)
      @player=@game.players.first
    end  

    test "can be created" do
      mt=Gamfora::Metric::Point.new(game: @game, name: "Stars", start_value: 5, )
      score=Gamfora::Score.new(player: @player, metric: mt)
      assert score.save
      assert_equal 5, score.value
    end  

    test "do not go below minimum if metric.min_value is set" do 
      mt=Gamfora::Metric::Point.new(game: @game, name: "Arrows", start_value: 0, min_value: -10 )
      score=Gamfora::Score.new(player: @player, metric: mt)
      assert_equal -10, score.set_value(-10)
      
      assert_equal -10, score.add_value(-1)
      assert_equal -10, score.substract_value(1)
      assert_equal -10, score.set_value(-11)
      
      score.send("write_attribute",:count, -11)
      refute score.valid?
      assert_equal ["Výsledná hodnota je menší než nejnižší metrikou povolená (-10)"], score.errors[:value]
    end

    test "do not go above maximum if metric.max_value is set" do 
      mt=Gamfora::Metric::Point.new(game: @game, name: "Arrows", start_value: 0, max_value: 10 )
      score=Gamfora::Score.new(player: @player, metric: mt)
      assert_equal 10, score.set_value(10)
      
      assert_equal 10, score.add_value(1)
      assert_equal 10, score.substract_value(-1)
      assert_equal 10, score.set_value(11)
      
      score.send("write_attribute",:count, 11)
      refute score.valid?
      assert_equal ["Výsledná hodnota je větší než nejvyšší metrikou povolená (10)"], score.errors[:value]
    end

    test "only one score for player and metric" do
      mt=Gamfora::Metric::Point.create!(game: @game, name: "Arrows", start_value: 0 )
      score=Gamfora::Score.create!(player: @player, metric: mt)
      score2=Gamfora::Score.new(player: @player, metric: mt)
      refute score2.save
      assert_equal ["Skóre pro tuto metriku již u hráče existuje"], score2.errors[:player]
    end  

    test "using incorrect value raise an Error" do
      skip
    end  


   

  end
end      
