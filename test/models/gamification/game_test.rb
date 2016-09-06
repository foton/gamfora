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

    test "can find games for user as owner" do
      game=Gamification::Game.create!(name: "My first game", owner: users(:game_owner))
      game=Gamification::Game.create!(name: "My first game2", owner: users(:player1))
      game=Gamification::Game.create!(name: "My first game3", owner: users(:player2))

      assert_equal(1,Gamification::Game.owned_by(users(:player1)).count )
      assert_equal(1,Gamification::Game.owned_by(users(:player2)).count ) 
      assert_equal((2+1),Gamification::Game.owned_by(users(:game_owner)).count ) 
    end  

    test "can find games for user as player" do
      skip
    end  


  end
end
