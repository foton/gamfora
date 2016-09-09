module Gamfora
  module ApplicationHelper
    def error_messages_for(n)
      "error"
    end  

    def current_user_owner_of_game?(game)
      game.owner == current_user
    end 

  
  end
end
