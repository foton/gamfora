require 'test_helper'

module Gamfora
  class RewardTest < ActiveSupport::TestCase

    def setup
      @game= gamfora_games(:got)
      @action=@game.actions.first
      @points_metric=@game.point_metrics.first
      @point_reward=Gamfora::Reward.new(action: @action, metric: @points_metric, count: 15, text_value:nil)
      assert @point_reward.present?
    end  

    test "can be created for points" do
      assert @point_reward.save
      assert_equal 15, @point_reward.value
    end  


    test "require action" do
      @point_reward.action=nil
      refute @point_reward.save
      assert ["x"], @point_reward.errors[:action]
    end

    test "require metric" do
      @point_reward.metric=nil
      refute @point_reward.save
      assert ["x"], @point_reward.errors[:metric]
    end

    test "must have value (count or text_value)" do
      @point_reward.count=nil
      @point_reward.text_value=nil

      refute @point_reward.save 

      assert_equal ["Hodnota odměny je prázdná"], @point_reward.errors[:count]
      assert_equal ["Hodnota odměny je prázdná"], @point_reward.errors[:text_value]
    end  

    test "must have correct type of value" do
      #:text value for point metric, which needs :count, so value is nil
      @point_reward.count=nil
      @point_reward.text_value="no_points?" 

      refute @point_reward.save 

      assert_equal ["Hodnota odměny je prázdná"], @point_reward.errors[:count]
      assert_equal ["Hodnota odměny je prázdná"], @point_reward.errors[:text_value]
    end  
    
    test "using incorrect state for state matric raise an Error" do
      skip
    end  

    test "can be sorted" do
      @point_reward.save!
      reward2=Gamfora::Reward.create!(action: @action, metric: @points_metric, count: (@point_reward.count-1), text_value:nil)

      assert_equal [reward2, @point_reward], [@point_reward, reward2].sort
    end  

    test "can display joined value" do
      @point_reward.count=20
      @point_reward.text_value=nil
      assert_equal "20", @point_reward.joined_value
      
      @point_reward.count=nil
      @point_reward.text_value="knife"
      assert_equal "knife", @point_reward.joined_value

      @point_reward.count=20
      @point_reward.text_value="knife"
      assert_equal "20x knife", @point_reward.joined_value
       
    end  

  end
end      
