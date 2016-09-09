require 'test_helper'

module Gamfora
  class GameTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "can be created" do
      game=Gamfora::Game.new(name: "My first game", owner: users(:game_owner))
      assert game.save
    end
      
    test "requires name" do 
      game=Gamfora::Game.new
      refute game.save
      refute game.errors[:name].empty?
    end

    test "requires user/game owner" do
      #no owner id
      game=Gamfora::Game.new
      refute game.save
      refute game.errors[:owner].empty?

      #not existing owner
      game=Gamfora::Game.new(owner_id: (User.last.id+1))
      refute game.save
      refute game.errors[:owner].empty?
    end  

    test "pass name of owner according to settings" do
      game=Gamfora::Game.new(name: "My first game", owner: users(:game_owner))
      assert_equal(users(:game_owner).username, game.owner_name)
      assert_equal(users(:game_owner).send(Gamfora.game_owner_name_attribute), game.owner_name)
    end

    test "can find games for user as owner" do
      game=Gamfora::Game.create!(name: "My first game", owner: users(:game_owner))
      game=Gamfora::Game.create!(name: "My first game2", owner: users(:user1))
      game=Gamfora::Game.create!(name: "My first game3", owner: users(:user2))

      assert_equal(1,Gamfora::Game.owned_by(users(:user1)).count )
      assert_equal(1,Gamfora::Game.owned_by(users(:user2)).count ) 
      assert_equal((2+1),Gamfora::Game.owned_by(users(:game_owner)).count ) 
    end  

    test "can find games for user as player" do
      assert_equal(1,Gamfora::Game.played_by(users(:user1)).count )
      assert_equal(2,Gamfora::Game.played_by(users(:user2)).count ) 
      assert_equal(2,Gamfora::Game.played_by(users(:user3)).count ) 
      assert_equal(0,Gamfora::Game.played_by(users(:game_owner)).count ) 
    end  

    test "have players" do
      game=gamfora_games(:got)
      assert_equal 3, game.players.count
    end  
   
    test "can find it's users" do
      game=gamfora_games(:got)
      assert_equal(1+3, game.users.size)
    end  


    test "can play action on behalf of user" do
      skip #gamfora_games(:got).play_action(:wedding_ruined, users(:user1))
    end  


  end
end
