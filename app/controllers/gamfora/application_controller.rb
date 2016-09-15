module Gamfora
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    
    # def current_user
    #   main_app.current_user
    # end  
      
    private
      def set_game
        @game = Game.find(params[:game_id])
      end

      def users_for_players
        Gamfora.player_class.all
      end  

      def kick_off_no_owners
        if current_user != @game.owner
          redirect_to games_url, alert: t("gamfora.not_your_own_game")
        end  
      end  

      def kick_off_no_owners_or_players
        unless @game.users.include?(current_user)
          redirect_to(games_url, alert: t("gamfora.not_your_game")) 
        end  
      end  

  end
end
