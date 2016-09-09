require_dependency "gamfora/application_controller"

module Gamfora
  class PlayersController < ApplicationController
    before_action :set_game
    before_action :set_player, only: [:show, :edit, :update, :destroy]

    # GET games/1/players
    def index
      @players = @game.players
    end

    # GET games/1/players/new
    def show
    end  

    # GET games/1/players/new
    def new
      @player = @game.players.build
    end

    # POST games/1/players
    def create
      @player = @game.players.build(player_params)

      if @player.save
        redirect_to(game_players_url(@player.game, anchor: "player_#{@player.id}"), notice: 'Player was successfully created.')
      else
        render action: 'new'
      end
    end
  
    # DELETE games/1/players/1
    def destroy
      @player.destroy

      redirect_to game_players_url(@game), notice: 'Player was successfully destroyed.'
    end

    private
      def set_player
        @player = @game.players.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def player_params
        params.require(:player).permit(:user_id, :game_id)
      end

  end
end
