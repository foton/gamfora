require_dependency "gamfora/application_controller"

module Gamfora
  class ActionsController < ApplicationController
    before_action :set_game
    before_action :set_action, only: [:show, :edit, :update, :destroy]

    # GET games/1/actions
    def index
      @actions = @game.actions
    end

    # GET games/1/actions/1
    def show
    end

    # GET games/1/actions/new
    def new
      @action = @game.actions.build
    end

    # GET games/1/actions/1/edit
    def edit
    end

    # POST games/1/actions
    def create
      @action = @game.actions.build(action_params)

      if @action.save
        redirect_to([@action.game, @action], notice: 'Action was successfully created.')
      else
        render action: 'new'
      end
    end

    # PUT games/1/actions/1
    def update
      if @action.update_attributes(action_params)
        redirect_to([@action.game, @action], notice: 'Action was successfully updated.')
      else
        render action: 'edit'
      end
    end

    # DELETE games/1/actions/1
    def destroy
      @action.destroy

      redirect_to game_actions_url(@game)
    end

    private
      def set_action
        @action = @game.actions.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def action_params
        params.require(:action).permit(:name, :game_id)
      end
  end

end
