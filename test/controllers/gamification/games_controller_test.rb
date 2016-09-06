require 'test_helper'

module Gamification
  class GamesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamification_games(:got)
    end

    test "should get index" do
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

    test "should get edit" do
      get edit_game_url(@game)
      assert_response :success
      assert_select 'h1', "Edit game: #{@game.name}"
    end

    test "should update game" do
      patch game_url(@game), params: { game: { name: @game.name } }
      assert_redirected_to game_url(@game)
    end

    test "should destroy game" do
      assert_difference('Game.count', -1) do
        delete game_url(@game)
      end

      assert_redirected_to games_url
    end
  end
end
