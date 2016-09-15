require 'test_helper'

module Gamfora
  class GamesControllerByStrangerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @non_player=users(:user4)
      ::ApplicationController.current_user=@non_player
    end

    test "stranger: should get empty index" do
      get games_url
  
      assert_response :success
      assert_select 'h1', "Seznam her"
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+0, game_table_rows.size) #header
      end 
      assert_select "a","Přidat Hru"
    end

    test "stranger: should get new" do
      get new_game_url
  
      assert_response :success
      assert_select 'h1', "Nová Hra"
      assert_select ".field input#game_name"
      assert_select ".actions input[type=submit]"
    end

    test "stranger: should create game" do
      name="Fresh game"
      assert_difference('Game.count') do
        post games_url, params: { game: { name: name } }
      end

      game=Game.find_by_name(name) 
      assert game.present?
      assert_redirected_to game_url(game)
    end

    test "stranger: should not show other game" do
      get game_url(@game)

      assert_redirected_to_games_with_message("Takovou hru nemáte v portfoliu!")
    end
   
    test "stranger: should not get edit" do
      get edit_game_url(@game)
      
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: should not be able to update game" do
      patch game_url(@game), params: { game: { name: "new_name" } }
      
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")

      #test for displaying flash
      follow_redirect!
      assert_select "#flashes .alert", "Takovou hru nemáte ve vlastnickém portfoliu!"
    end

    test "stranger: should not be able to destroy game" do
      assert_no_difference('Game.count') do
        delete game_url(@game)
      end

      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

  end
end
