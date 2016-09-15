require 'test_helper'

module Gamfora
  class MetricsControllerByStrangerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @metric = gamfora_metric_points(:money)
      ::ApplicationController.current_user=users(:user4)
    end

    test "stranger: should not get index of game metrics" do
      get game_metrics_url(@game)
      assert_redirected_to_games_with_message("Takovou hru nemáte v portfoliu!")
    end

    test "stranger: should not show metric " do
      get game_metric_url(@game, @metric)
      assert_redirected_to_games_with_message("Takovou hru nemáte v portfoliu!")
    end

    test "stranger: can not get new" do
      get new_game_metric_url(@game)
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: should not create metric" do
      assert_no_difference('Metric::Base.count') do
        post game_metrics_url(@game), params: { metric: { game_id: @game.id, type: 'Point', name: "MyPoints", start_value: 0 } }
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: can not get edit" do
      get edit_game_metric_url(@game,@metric)
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: should not update metric" do
      assert_no_difference('Metric::Base.count') do
        patch game_metric_url(@game,@metric), params: { metric: { game_id: @game.id, type: 'Point', name: "MyPoints2", start_value: 2 } }
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: should not destroy" do
      assert_no_difference('Metric::Base.count') do
        delete game_metric_url(@game, @metric)
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

  end
end
