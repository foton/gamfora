require 'test_helper'

module Gamfora
  class GamesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      ::ApplicationController.current_user=users(:game_owner)
    end

    test "should get index of games owned by current_user in English" do
      get games_url, params: {locale: :en}
  
      assert_response :success
      assert_select 'h1', "List of games" #explicitly demanded EN language
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+Gamfora::Game.count, game_table_rows.size) #header+fixtures
      end 
      assert_select "a","Create new Game"

    end

    test "should get index of games owned by current_user in default Czech" do
      get games_url
  
      assert_response :success
      assert_select 'h1', "Seznam her"
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+Gamfora::Game.count, game_table_rows.size) #header+fixtures
      end 
      
      assert_select "a","Přidat Hru"
      assert_select 'table#games' do
        assert_select "tr#game_#{@game.id}" do
          assert_select 'td.show' do 
            assert_select "a","Detail" 
          end  
          assert_select 'td.edit' do 
            assert_select "a","Editace" 
          end  
          assert_select 'td.destroy' do
            assert_select "a","Zrušit" 
          end
        end
      end
    end

    test "should get empty index of games if current_user do not own any game" do
      rambo_user=::User.create!(name: "John Rambo", username: "rambo")
      ::ApplicationController.current_user=rambo_user
      get games_url
  
      assert_response :success
      assert_select 'h1', "Seznam her"
      assert_select("#games tr") do |game_table_rows|
        assert_equal(1+0, game_table_rows.size) #header
      end 
      assert_select "a","Přidat Hru"
    end

    test "should get new" do
      get new_game_url
  
      assert_response :success
      assert_select 'h1', "Nová Hra"
      assert_select ".field input#game_name"
      assert_select ".actions input[type=submit]"
    end

    test "should create game" do
      name="Fresh game"
      assert_difference('Game.count') do
        post games_url, params: { game: { name: name } }
      end

      game=Game.find_by_name(name) 
      assert game.present?
      assert_redirected_to game_url(game)
    end

    test "should show game for owner" do
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

    test "should show game for player" do
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

    test "should not show game which is not owned by current_user" do
      ::ApplicationController.current_user=users(:player1)
      
      get game_url(@game)

      assert_redirected_to games_url
      assert(flash[:error].present?)
    end

    test "should get edit" do
      get edit_game_url(@game)
      assert_response :success
      assert_select 'h1', "Úprava hry: #{@game.name}"
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
