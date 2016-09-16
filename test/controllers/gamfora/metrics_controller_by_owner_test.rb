require 'test_helper'

module Gamfora
  class MetricsControllerByOwnerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @metric = gamfora_metric_points(:money)
      @owner=users(:game_owner)
      ::ApplicationController.current_user=@owner
    end

    test "owner: should get index of game metrics" do
      get game_metrics_url(@game)
      assert_response :success

      assert_select 'h1', "Seznam metrik hry 'Game of Thrones'"
      assert_select("#game_metrics tr") do |game_table_rows|
        assert_equal(1+@game.metrics.count, game_table_rows.size) #header+fixtures
      end 

      metric=@game.metrics.first
      assert_select 'table#game_metrics' do
        assert_select "tr#metric_#{metric.id}" do
          assert_tr_with_actions([:show, :edit,:destroy], "metrics","Zrušit")
        end
      end

    end

    test "owner: should show metric " do
      get game_metric_url(@game, @metric)
      assert_response :success

      assert_select 'h1', "Metrika '#{@metric.name}' ve hře '#{@game.name}'"
    end

    test "owner: can get new" do
      get new_game_metric_url(@game)
      assert_response :success

      assert_select 'h1', "Nová metrika do hry 'Game of Thrones'"
  
      assert_select ".field input#metric_name"
      assert_select ".field input#metric_start_value"
      assert_select ".field input#metric_min_value"
      assert_select ".field input#metric_max_value"

      assert_select "select#metric_type option" do |types|
        assert_equal(["Gamfora::Metric::Point"].size, types.size)
      end  

      assert_select ".actions input[type=submit]"
    end

    test "owner: should create metric" do
      name="MyPoints"
      assert_difference('Metric::Any.count',+1) do
        post game_metrics_url(@game), params: { metric: { game_id: @game.id, type: 'Gamfora::Metric::Point', name: name, start_value: 0 } }
      end
      
      mts=Metric::Any.where(game: @game, name: name)
      assert_equal 1, mts.count

      assert_redirected_to game_metric_url(@game, mts.first )
      assert_equal "Metrika '#{name}' byla úspěšně přidána do hry '#{@game.name}'.", flash[:notice]
    
      #test for displaying flash
      follow_redirect!
      assert_select "#flashes .notice","Metrika '#{name}' byla úspěšně přidána do hry '#{@game.name}'."
      assert_select 'h1', "Metrika '#{name}' ve hře '#{@game.name}'"
    end

    test "create point metric" do
      skip
    end  

    test "create set/badges metric" do
      skip
    end  

    test "create state/level metric" do
      skip
    end  


    test "owner: can get edit" do
      get edit_game_metric_url(@game, @metric)
      assert_response :success
      assert_select 'h1', "Úprava metriky '#{@metric.name}' ve hře 'Game of Thrones'"
  
      assert_select ".field input#metric_name"
      assert_select ".field input#metric_start_value"
      assert_select ".field input#metric_min_value"
      assert_select ".field input#metric_max_value"

      #from odd reason assert_select ".field input#metric_type:disabled" cannot be used directly => RuntimeError: xmlXPathCompOpEval: function disabled not found
      assert_select ".field input#metric_type" do |input|
        assert input.attr("disabled").present?
      end  

      assert_select ".actions input[type=submit]"
    end

    test "test edit for set metrics" do
      skip
    end
      
    test "test edit for state metrics" do
      skip
    end

    test "owner: should update metric" do
      orig_metric=@metric.dup
      assert_no_difference('Metric::Any.count') do
        patch game_metric_url(@game, @metric), params: { metric: { game_id: @game.id, type: 'XPoint', name: "MyPoints2", start_value: 2 } }
      end
      
      assert_redirected_to game_metric_url(@game, @metric)
      @metric.reload
      #no type change is allowed
      assert_equal "Gamfora::Metric::Point", @metric.type
      assert @metric.is_a?(Gamfora::Metric::Point)

      assert_equal "MyPoints2", @metric.name
      assert_equal 2, @metric.start_value
      assert_equal orig_metric.min_value, @metric.min_value
      assert_equal orig_metric.max_value, @metric.max_value

    end

    test "owner: should destroy" do
      assert_difference('Metric::Any.count',-1) do
        delete game_metric_url(@game, @metric)
      end
      assert_redirected_to game_metrics_url(@game)
      assert_equal "Metrika '#{@metric.name}' byla úspěšně smazána ze hry '#{@game.name}'.", flash[:notice]
    end
  end
end
