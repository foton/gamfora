require 'test_helper'

module Gamification
  class GameControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
   
    def test_index 
      get games_url
    end  
  end
end

