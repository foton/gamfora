require_dependency "gamification/application_controller"

module Gamification
  class GamesController < ApplicationController
    before_action :set_game, only: [:show, :edit, :update, :destroy]
    before_action :kick_off_no_owners, only: [:edit, :update, :destroy]
    before_action :kick_off_no_owners_or_players, only: [:show]

    # GET /games
    def index
      @games = Game.all
    end

    # GET /games/1
    def show
    end

    # GET /games/new
    def new
      @game = Game.new
    end

    # GET /games/1/edit
    def edit
    end

    # POST /games
    def create
      @game = Game.new(game_params)
      @game.owner=current_user

      if @game.save
        redirect_to @game, notice: 'Game was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /games/1
    def update
      if @game.update(game_params)
        redirect_to @game, notice: 'Game was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /games/1
    def destroy
      @game.destroy
      redirect_to games_url, notice: 'Game was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_game
        @game = Game.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def game_params
        params.require(:game).permit(:name)
      end

      def kick_off_no_owners
        if current_user != @game.owner
          flash[:error]="No such game founded between your games!"
          redirect_to(games_url) 
        end  
      end  

      def kick_off_no_owners_or_players
        unless (@game.players+[@game.owner]).include?(current_user)
          flash[:error]="No such game founded between your games!"
          redirect_to(games_url) 
        end  
      end  
  end
end
