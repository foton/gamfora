require 'test_helper'

module Gamfora
  class MetricsControllerByPlayerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @metric = gamfora_metric_points(:money)
      
      ::ApplicationController.current_user=users(:user2)
    end


    test "player: should get index of game metrics" do
      get game_metrics_url(@game)
      assert_response :success

      assert_select 'h1', "Seznam metrik hry 'Game of Thrones'"
      assert_select("#game_metrics tr") do |game_table_rows|
        assert_equal(1+@game.metrics.count, game_table_rows.size) #header+fixtures
      end 

      metric=@game.metrics.first
      assert_select 'table#game_metrics' do
        assert_select "tr#metric_#{metric.id}" do
          assert_tr_with_actions([:show], "metrics","Vyřadit ze hry")
        end
      end

    end

    test "player: should show metric " do
      get game_metric_url(@game, @metric)
      assert_response :success

      assert_select 'h1', "Metrika '#{@metric.name}' ve hře '#{@game.name}'"
    end

    test "player: can not get new" do
      get new_game_metric_url(@game)
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: should not create metric" do
      assert_no_difference('Metric::Any.count') do
        post game_metrics_url(@game), params: { metric: { game_id: @game.id, type: 'Point', name: "MyPoints", start_value: 0 } }
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: can not get edit" do
      get edit_game_metric_url(@game, @metric)
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: should not update metric" do
      assert_no_difference('Metric::Any.count') do
        patch game_metric_url(@game, @metric), params: { metric: { game_id: @game.id, type: 'Point', name: "MyPoints2", start_value: 2 } }
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: should not destroy" do
      assert_no_difference('Metric::Any.count') do
        delete game_metric_url(@game, @metric)
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end
   
  end
end
