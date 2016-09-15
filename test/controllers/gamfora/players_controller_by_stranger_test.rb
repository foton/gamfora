require 'test_helper'

module Gamfora
  class PlayersControllerByStrangerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @player = gamfora_players(:got_player1)
      @non_player=users(:user4)
      ::ApplicationController.current_user=@non_player
    end

    test "stranger: should not get index of game players" do
      get game_players_url(@game)
      assert_redirected_to_games_with_message("Takovou hru nemáte v portfoliu!")
    end

    test "stranger: can not get new" do
      get new_game_player_url(@game)
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: should not create player" do
      user=users(:user4)
      assert_no_difference('Player.count') do
        post game_players_url(@game), params: { player: { game_id: @game.id, user_id: user.id } }
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "stranger: should not show player " do
      get game_player_url(@game, @player)
      assert_redirected_to_games_with_message("Takovou hru nemáte v portfoliu!")
    end

    test "stranger: should not destroy" do
      assert_no_difference('Player.count') do
        delete game_player_url(@game, @player)
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

  end
end
