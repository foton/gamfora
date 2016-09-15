require 'test_helper'

module Gamfora
  class PlayerTest < ActiveSupport::TestCase

    test "can be created" do
      player=Gamfora::Player.new(game: gamfora_games(:got), user: users(:user4))
      assert player.save
    end
      
    test "requires game" do 
      player=Gamfora::Player.new(user: users(:user3))
      refute player.save
      refute player.errors[:game].empty?
    end

    test "requires user" do
      #no user id
      player=Gamfora::Player.new(game: gamfora_games(:got))
      refute player.save
      refute player.errors[:user].empty?

      #not existing owner
      player=Gamfora::Player.new(game: gamfora_games(:got), user_id: (User.last.id+1))
      refute player.save
      refute player.errors[:user].empty?
    end 

    test "pass name of user according to settings" do
      player=Gamfora::Player.new(game: gamfora_games(:got), user: users(:user3))
      assert_equal(users(:user3).name, player.name)
      assert_equal(users(:user3).send(Gamfora.player_name_attribute), player.name)
    end  

    test "user cannot have more than one player for game" do
      #first time it is from fixtures
      player_second_time=Gamfora::Player.new(game: gamfora_games(:got), user: users(:user3))
      refute player_second_time.save
      refute player_second_time.errors[:user].empty?
    end  

    test "can find players for user" do
      assert_equal(1,Gamfora::Player.all_for(users(:user1)).count )
      assert_equal(2,Gamfora::Player.all_for(users(:user2)).count ) 
      assert_equal(2,Gamfora::Player.all_for(users(:user3)).count ) 
      assert_equal(0,Gamfora::Player.all_for(users(:game_owner)).count ) 
    end 

    test "can play an action" do
      skip
    end

    test "have scores" do
      skip
    end

    test "on create build new scores for each game metrics" do
      skip
    end  


  end
end
