require 'test_helper'

module Gamfora
  class ActionTest < ActiveSupport::TestCase

    def setup
      @game= gamfora_games(:got)
      @rewards=[
        Gamfora::Reward.new(metric: gamfora_metric_points(:money), count: 10),
        Gamfora::Reward.new(metric: gamfora_metric_points(:knights), count: -5),
      ]
    end 

    test "can be created" do

      action=Gamfora::Action.new(name: "Kill any king", key: :kill_any_king, game: @game)
      action.rewards = @rewards
      assert action.save

      assert_equal @rewards.sort, Gamfora::Reward.where(action: action).sort
    end  

    test "should have rewards, but it is not required" do
      action=Gamfora::Action.new(name: "Kill any king",key: :kill_any_king, game: @game, rewards:[])
      assert action.save
    end

    test "require game" do
      action=Gamfora::Action.new(name: "Kill any king", key: :kill_any_king, rewards: @rewards)
      refute action.save
      assert_equal ["musí existovat", "je povinná položka"], action.errors[:game]
    end

    test "require key" do
      action=Gamfora::Action.new(name: "Kill any king", game: @game, rewards: @rewards)
      refute action.save
      assert_equal ["je povinná položka"], action.errors[:key]
    end

    test "have unique key in game scope" do
      existing_action=@game.actions.first
      assert existing_action.present?

      action=Gamfora::Action.new(name: existing_action.name+"2", key: existing_action.key, game: @game, rewards: @rewards)
      refute action.save
      assert_equal ["Akce s klíčem '#{action.key}' již ve hře '#{@game.name}' existuje."], action.errors[:key]
    end

    test "can be played by player" do
      existing_action=@game.actions.first
      player=@game.players.first

      player_updated_scores=existing_action.play_by(player)
      assert player_updated_scores.present?
    end

    test "can have limits for repetitive plays" do
      skip
    end

    test "create event after succesfull play" do
      skip
    end


  end
end
