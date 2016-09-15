require_dependency "gamfora/application_controller"

module Gamfora
  class PlayersController < ApplicationController
    before_action :set_game
    before_action :set_player, only: [:show, :destroy]
    before_action :kick_off_no_owners, only: [:new, :create, :destroy]
    before_action :kick_off_no_owners_or_players, only: [:index, :show]

    # GET games/1/players
    def index
      @players = @game.players
    end

    # GET games/1/players/2
    def show
    end  

    # GET games/1/players/new
    def new
      @player = @game.players.build
      @users=users_for_players
    end

    # POST games/1/players
    def create
      @player = @game.players.build(player_params)
      @player.game=@game

      if @player.save
        redirect_to(game_players_url(@player.game, anchor: "player_#{@player.id}"), notice: t('gamfora.player.views.create.success_message', name: @player.name, game_name: @game.name))
      else
        @users=users_for_players
        render action: 'new'
      end
    end
  
    # DELETE games/1/players/1
    def destroy
      @player.destroy

      redirect_to game_players_url(@game), notice: t('gamfora.player.views.destroy.success_message', name: @player.name, game_name: @game.name)
    end

    private
      def set_player
        @player = @game.players.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def player_params
        params.require(:player).permit(:user_id)
      end

  end
end
