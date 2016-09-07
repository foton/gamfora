require_dependency "gamification/application_controller"

module Gamification
  class PlayersController < ApplicationController
    before_action :set_game
    before_action :set_player, only: [:show, :edit, :update, :destroy]

    # GET games/1/players
    def index
      @players = @game.players
    end

    # GET games/1/players/1
    def show
    end

    # GET games/1/players/new
    def new
      @player = @game.players.build
    end

    # GET games/1/players/1/edit
    def edit
    end

    # POST games/1/players
    def create
      @player = @game.players.build(player_params)

      if @player.save
        redirect_to(game_player_url(@player.game, @player), notice: 'Player was successfully created.')
      else
        render action: 'new'
      end
    end

    # PATCH/PUT games/1/players/1
    def update
      if @player.update_attributes(player_params)
        @player.reload
        redirect_to(game_player_url(@player.game, @player), notice: 'Player was successfully updated.')
      else
        render action: 'edit'
      end
    end

    # DELETE games/1/players/1
    def destroy
      @player.destroy

      redirect_to game_players_url(@game), notice: 'Player was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_game
        @game = Game.find(params[:game_id])
      end

      def set_player
        @player = @game.players.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def player_params
        params.require(:player).permit(:user_id, :game_id)
      end




  end
end
