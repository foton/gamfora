require 'test_helper'

module Gamification
  class GamesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamification_games(:got)
      ::ApplicationController.current_user=users(:game_owner)
    end

    test "should get index of games owned by current_user" do
      get games_url
  
      assert_response :success
      assert_select 'h1', "List of games"
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+Gamification::Game.count, game_table_rows.size) #header+fixtures
      end 
    end

    test "should get new" do
      get new_game_url
  
      assert_response :success
      assert_select 'h1', "New Game"
      assert_select ".field input#game_name"
      assert_select ".actions input[type=submit]"
    end

    test "should create game" do
      assert_difference('Game.count') do
        post games_url, params: { game: { name: @game.name } }
      end

      assert_redirected_to game_url(Game.last)
    end

    test "should show game" do
      get game_url(@game)
  
      assert_response :success
      assert_select 'h1', "Game: #{@game.name}"
    end

    test "should not show game which is not owned by current_user" do
      ::ApplicationController.current_user=users(:player1)
      
      get game_url(@game)

      assert_redirected_to games_url
      assert(flash[:error].present?)
    end

    test "should get edit" do
      get edit_game_url(@game)
      
      assert_response :success
      assert_select 'h1', "Edit game: #{@game.name}"
    end

    test "should not get edit for game which is not owned by current_user" do
      ::ApplicationController.current_user=users(:player1)
      get edit_game_url(@game)
      
      assert_redirected_to games_url
      assert(flash[:error].present?)
    end

    test "should update game" do
      patch game_url(@game), params: { game: { name: @game.name } }
      assert_redirected_to game_url(@game)
    end

    test "should not update game which is not owned by current_user" do
      ::ApplicationController.current_user=users(:player2)

      patch game_url(@game), params: { game: { name: @game.name } }
      
      assert_redirected_to games_url
      assert(flash[:error].present?)
    end

    test "should destroy game" do
      assert_difference('Game.count', -1) do
        delete game_url(@game)
      end

      assert_redirected_to games_url
    end

    test "should not destroy game which is not owned by current_user" do
      ::ApplicationController.current_user=users(:player2)
      
      assert_no_difference('Game.count') do
        delete game_url(@game)
      end

      assert_redirected_to games_url
      assert(flash[:error].present?)
    end

  end
end
