require 'test_helper'

module Gamfora
  class PlayersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @player = gamfora_players(:got_player1)
      ::ApplicationController.current_user=users(:game_owner)
    end

    test "should get index for game owner" do
      get game_players_url(@game)
      assert_response :success

      player=@game.players.first
      assert_select 'table#game_players' do
        assert_select "tr#player_#{player.id}" do
          assert_select 'td.show' do 
            assert_select "a","Detail" 
          end  

          assert_select 'td.edit', false, "There should be no edit for players"
          assert_select "a",{text: "Editace", count: 0}, "There should be no edit for players"
          
          assert_select 'td.destroy' do
            assert_select "a","Vyřadit ze hry" 
          end
        end
      end

    end

    test "should get index for game player" do
      ::ApplicationController.current_user=@game.players.first.user

      get game_players_url(@game)
      assert_response :success

      player=@game.players.first
      assert_select 'table#game_players' do
        assert_select "tr#player_#{player.id}" do
          assert_select 'td.show' do 
            assert_select "a","Detail" 
          end  

          assert_select 'td.edit', false, "There should be no edit for players"
          assert_select "a",{text: "Editace", count: 0}, "There should be no edit for players"
          
          assert_select 'td.destroy', false
          assert_select "a",{ text: "Vyřadit ze hry" , count: 0}
        end
      end

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

      assert_redirected_to game_players_url(@game, anchor: "player_#{Gamfora::Player.last.id}")
    end

    test "should show player" do
      get game_player_url(@player.game, @player)
      assert_response :success
    end

    # test "should NOT get edit, destroy and create instead" do
    #   get (game_player_url(@game, @player)+"/edit")
    #   assert_redirected_to game_players_url(@game)
    # end

    # test "should NOT update player, destroy and create instead" do
    #   patch game_player_url(@player.game, @player), params: { player: { game_id: gamfora_games(:dn3d).id, user_id: @player.user_id } }
    #   assert_redirected_to game_player_url(gamfora_games(:dn3d), @player)
    # end

    test "should destroy player" do
      assert_difference('Player.count', -1) do
        delete game_player_url(@game, @player)
      end

      assert_redirected_to game_players_url(@game)
    end

  end
end
