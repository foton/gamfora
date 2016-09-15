require 'test_helper'

module Gamfora
  class GamesControllerByPlayerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      @player=users(:user1)
      ::ApplicationController.current_user=@player
    end

     test "player: should get index of games played by current_user in default Czech" do
      get games_url
  
      assert_response :success
      assert_select 'h1', "Seznam her"
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+1, game_table_rows.size) #header+GameOfThrones
      end 
      
      assert_select "a","Přidat Hru"

      assert_select 'table#games' do
        assert_select "tr#game_#{@game.id}" do
          assert_tr_with_actions([:show], "games","Zrušit")
        end
      end
    end

    test "player: should get new" do
      get new_game_url
  
      assert_response :success
      assert_select 'h1', "Nová Hra"
      assert_select ".field input#game_name"
      assert_select ".actions input[type=submit]"
    end

    test "player: should create game" do
      name="Fresh game"
      assert_difference('Game.count') do
        post games_url, params: { game: { name: name } }
      end

      game=Game.find_by_name(name) 
      assert game.present?
      assert_redirected_to game_url(game)
    end
  
    test "player: should show game" do
      ::ApplicationController.current_user=@game.players.first.user

      get game_url(@game)
      
      assert_response :success
      assert_select 'h1', "Hra: #{@game.name}"
      assert_select 'h2', "Hráči"
      
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
   
    test "player: should not get edit" do
      get edit_game_url(@game)
     
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end

    test "player: should not be able to update game" do
      patch game_url(@game), params: { game: { name: "new_name" } }
      
      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")

      #test for displaying flash
      follow_redirect!
      assert_select "#flashes .alert", "Takovou hru nemáte ve vlastnickém portfoliu!"
    end

    test "player: should not be able to destroy game" do
      assert_no_difference('Game.count') do
        delete game_url(@game)
      end

      assert_redirected_to_games_with_message("Takovou hru nemáte ve vlastnickém portfoliu!")
    end
   
   
  end
end
