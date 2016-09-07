require 'test_helper'

module Gamification
  class GameTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "can be created" do
      game=Gamification::Game.new(name: "My first game", owner: users(:game_owner))
      assert game.save
    end
      
    test "requires name" do 
      game=Gamification::Game.new
      refute game.save
      refute game.errors[:name].empty?
    end

    test "requires user/game owner" do
      #no owner id
      game=Gamification::Game.new
      refute game.save
      refute game.errors[:owner].empty?

      #not existing owner
      game=Gamification::Game.new(owner_id: (User.last.id+1))
      refute game.save
      refute game.errors[:owner].empty?
    end  

    test "pass name of owner according to settings" do
      game=Gamification::Game.new(name: "My first game", owner: users(:game_owner))
      assert_equal(users(:game_owner).username, game.owner_name)
      assert_equal(users(:game_owner).send(Gamification.game_owner_name_attribute), game.owner_name)
    end

    test "can find games for user as owner" do
      game=Gamification::Game.create!(name: "My first game", owner: users(:game_owner))
      game=Gamification::Game.create!(name: "My first game2", owner: users(:user1))
      game=Gamification::Game.create!(name: "My first game3", owner: users(:user2))

      assert_equal(1,Gamification::Game.owned_by(users(:user1)).count )
      assert_equal(1,Gamification::Game.owned_by(users(:user2)).count ) 
      assert_equal((2+1),Gamification::Game.owned_by(users(:game_owner)).count ) 
    end  

    test "can find games for user as player" do
      assert_equal(1,Gamification::Game.played_by(users(:user1)).count )
      assert_equal(2,Gamification::Game.played_by(users(:user2)).count ) 
      assert_equal(2,Gamification::Game.played_by(users(:user3)).count ) 
      assert_equal(0,Gamification::Game.played_by(users(:game_owner)).count ) 
    end  


  end
end
