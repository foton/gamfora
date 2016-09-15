require 'test_helper'

module Gamfora
  class PlayersControllerByOwnerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @player = gamfora_players(:got_player1)
      ::ApplicationController.current_user=users(:game_owner)
    end

    test "owner: should get index of game players" do
      get game_players_url(@game)
      assert_response :success

      assert_select 'h1', "Seznam hráčů hry 'Game of Thrones'"
      assert_select("#game_players tr") do |game_table_rows|
        assert_equal(1+@game.players.count, game_table_rows.size) #header+fixtures
      end 

      player=@game.players.first
      assert_select 'table#game_players' do
        assert_select "tr#player_#{player.id}" do
          assert_tr_with_actions([:show, :destroy], "players","Vyřadit ze hry")
        end
      end

    end

    test "owner: can get new, to add player " do
      get new_game_player_url(@game)
      assert_response :success

      assert_select 'h1', "Nový hráč do hry 'Game of Thrones'"
 
      assert_select "select#player_user_id option" do |user_opts|
        assert_equal(Gamfora.player_class.count, user_opts.size)
      end  

      assert_select ".actions input[type=submit]"
    end

    test "owner: should create player" do
      user=users(:user4)
      assert_difference('Player.count', +1) do
        post game_players_url(@game), params: { player: { game_id: @game.id, user_id: user.id } }
      end

      assert_redirected_to game_players_url(@game, anchor: "player_#{Gamfora::Player.last.id}")
      assert_equal "Hráč '#{user.name}' byl úspěšně přidán do hry '#{@game.name}'.", flash[:notice]
    
      assert_equal 1, Player.where(game: @game, user: user).count

      #test for displaying flash
      follow_redirect!
      assert_select "#flashes .notice","Hráč '#{user.name}' byl úspěšně přidán do hry '#{@game.name}'."
      assert_select 'table#game_players' do
        assert_select "td",user.name
      end  
    end

    test "owner: should not create player second time for user" do
      user=users(:user3) #already have player for @game
      assert_no_difference('Player.count') do
        post game_players_url(@game), params: { player: { game_id: @game.id, user_id: user.id } }
      end
    
      assert_equal 1, Player.where(game: @game, user: user).count

      assert_response :success   #rerender of new    
      #test for displaying error messages
      assert_select "#error_messages", "User Uživatel již je hráčem této hry!"
      #no field_with_errors is set     assert_select ".field_with_errors #player_user_id"
    end

    test "owner: should show player for game owner" do
      get game_player_url(@game, @player)
      assert_response :success

      assert_select 'h1', "Hráč '#{@player.name}' ve hře '#{@game.name}'"
      
      #scores
      #events      
    end

    # test "owner: should NOT get edit, destroy and create instead" do
    #   get (game_player_url(@game, @player)+"/edit")
    #   assert_redirected_to game_players_url(@game)
    # end

    # test "owner: should NOT update player, destroy and create instead" do
    #   patch game_player_url(@player.game, @player), params: { player: { game_id: gamfora_games(:dn3d).id, user_id: @player.user_id } }
    #   assert_redirected_to game_player_url(gamfora_games(:dn3d), @player)
    # end

    test "owner: should destroy player" do
      assert_difference('Player.count', -1) do
        delete game_player_url(@game, @player)
      end
      assert_redirected_to game_players_url(@game)
      assert_equal "Hráč '#{@player.name}' byl úspěšně vyřazen ze hry '#{@game.name}'.", flash[:notice]
    end

  end
end
