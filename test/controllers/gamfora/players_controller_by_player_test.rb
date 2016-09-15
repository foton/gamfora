require 'test_helper'

module Gamfora
  class PlayersControllerByPlayerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @player = gamfora_players(:got_player1)
      ::ApplicationController.current_user=@player.user
    end

    test "player: should get index of game players" do
      get game_players_url(@game)
      assert_response :success

      assert_select 'h1', "Seznam hráčů hry 'Game of Thrones'"
      assert_select("#game_players tr") do |game_table_rows|
        assert_equal(1+@game.players.count, game_table_rows.size) #header+fixtures
      end 

      player=@game.players.first
      assert_select 'table#game_players' do
        assert_select "tr#player_#{player.id}" do
          assert_tr_with_actions([:show], "players","Vyřadit ze hry")
        end
      end

    end

    test "player: can not get new" do
      get new_game_player_url(@game)
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: should not create player" do
      user=users(:user4)
      assert_no_difference('Player.count') do
        post game_players_url(@game), params: { player: { game_id: @game.id, user_id: user.id } }
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: should show him/herself " do
      get game_player_url(@game, @player)
      assert_response :success

      assert_select 'h1', "Hráč '#{@player.name}' ve hře '#{@game.name}'"
      
      #scores
      #events      
    end

    test "player: should show other player of game" do
      get game_player_url(@game, gamfora_players(:got_player2))
      assert_response :success

      assert_select 'h1', "Hráč '#{gamfora_players(:got_player2).name}' ve hře '#{@game.name}'"
      
      #scores
      #events      
    end

    test "player: should not destroy" do
      assert_no_difference('Player.count') do
        delete game_player_url(@game, @player)
      end
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

  end
end
