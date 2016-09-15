require 'test_helper'

module Gamfora
  class GamesControllerByOwnerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      ::ApplicationController.current_user=users(:game_owner)
    end

    test "owner: should get index of games owned by current_user in English" do
      get games_url, params: {locale: :en}
  
      assert_response :success
      assert_select 'h1', "List of games" #explicitly demanded EN language
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+Gamfora::Game.count, game_table_rows.size) #header+fixtures
      end 
      assert_select "a","Create new Game"

    end

    test "owner: should get index of games owned by current_user in default Czech" do
      get games_url
  
      assert_response :success

      assert_select 'h1', "Seznam her"
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+Gamfora::Game.count, game_table_rows.size) #header+fixtures
      end 
      
      assert_select "a","Přidat Hru"
      assert_select 'table#games' do
        assert_select "th","Název" 
        assert_select "th a","Přidat Hru"

        assert_select "tr#game_#{@game.id}" do
          assert_tr_with_actions([:show, :edit, :destroy], "games","Zrušit")
        end
      end
    end
  
    test "owner: should get new" do
      get new_game_url
  
      assert_response :success

      assert_select 'h1', "Nová Hra"
      assert_select ".field input#game_name"
      assert_select ".actions input[type=submit]"
    end

    test "owner: should create game" do
      name="Fresh game"
      assert_difference('Game.count') do
        post games_url, params: { game: { name: name } }
      end

      game=Game.find_by_name(name) 
      assert game.present?
      assert_redirected_to game_url(game)
    end

    test "owner: should show game for owner" do
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
          
          assert_select 'td.destroy' do
            assert_select "a","Vyřadit ze hry" 
          end
        end
      end
    end

    test "owner: should get edit" do
      get edit_game_url(@game)
      assert_response :success
      assert_select 'h1', "Úprava hry: #{@game.name}"
    end

    test "owner: should update game" do
      patch game_url(@game), params: { game: { name: "new_name" } }

      assert_redirected_to game_url(@game)
      @game.reload
      assert_equal "new_name", @game.name
    end

    test "owner: should not update game if name is blank" do
      patch game_url(@game), params: { game: { name: "" } }
      
      assert_response :success      
      #test for displaying error messages
      assert_select "#error_messages", "Název je povinná položka"
      assert_select ".field_with_errors #game_name"
    end

    test "owner: should destroy game" do
      assert_difference('Game.count', -1) do
        delete game_url(@game)
      end

      assert_redirected_to games_url
    end

  end
end
