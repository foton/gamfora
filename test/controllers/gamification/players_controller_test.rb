require 'test_helper'

module Gamification
  class PlayersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamification_games(:got)
      @player = gamification_players(:got_player1)
    end

    test "should get index" do
      get game_players_url(@game)
      assert_response :success
    end

    test "should get new" do
      get new_game_player_url(@game)
      assert_response :success
    end

    test "should create player" do
      user=users(:user2)
      assert_difference('Player.count') do
        post game_players_url(@game), params: { player: { game_id: @game.id, user_id: user.id } }
      end

      assert_redirected_to game_player_url(@game, Player.last)
    end

    test "should show player" do
      get game_player_url(@player.game, @player)
      assert_response :success
    end

    test "should get edit" do
      get edit_game_player_url(@game, @player)
      assert_response :success
    end

    test "should update player" do
      patch game_player_url(@player.game, @player), params: { player: { game_id: gamification_games(:dn3d).id, user_id: @player.user_id } }
      assert_redirected_to game_player_url(gamification_games(:dn3d), @player)
    end

    test "should destroy player" do
      assert_difference('Player.count', -1) do
        delete game_player_url(@game, @player)
      end

      assert_redirected_to game_players_url(@game)
    end

  end
end
