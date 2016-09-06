require 'test_helper'

module Gamification
  class GameTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "requires name" do 
      game=Gamification::Game.new
      refute game.save
    end
  end
end
