require_dependency "gamfora/application_controller"

module Gamfora
  class MetricsController < ApplicationController
    before_action :set_game
    before_action :set_metric, only: [:show, :edit, :update, :destroy]
    before_action :kick_off_no_owners, only: [:new, :create, :edit, :update, :destroy]
    before_action :kick_off_no_owners_or_players, only: [:index, :show]


    # GET games/1/metrics
    def index
      @metrics = @game.metrics
    end

    # GET games/1/metrics/1
    def show
    end

    # GET games/1/metrics/new
    def new
      @metric = Gamfora::Metric::Point.new(game: @game)
    end

    # GET games/1/metrics/1/edit
    def edit
    end

    # POST games/1/metrics
    def create
      @metric = @game.metrics.build(metric_params)

      if @metric.save
        redirect_to(game_metric_url(@metric.game, @metric), notice: t('gamfora.metric.views.create.success_message.', name: @metric.name, game_name: @game.name))
      else
        render action: 'new'
      end
    end

    # PATCH games/1/metrics/1
    #`type` of metric cannot be changed, use destroy and create
    def update
      mp=metric_params
      mp.delete(:type)

      if @metric.update_attributes(mp)
        redirect_to(game_metric_url(@metric.game, @metric), notice: t('gamfora.metric.views.update.success_message.', name: @metric.name, game_name: @game.name))
      else
        render action: 'edit'
      end
    end

    # DELETE games/1/metrics/1
    def destroy
      @metric.destroy

      redirect_to(game_metrics_url(@game), notice: t('gamfora.metric.views.destroy.success_message.', name: @metric.name, game_name: @game.name))
    end

    private
      def set_metric
        @metric = @game.metrics.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def metric_params
        params.require(:metric).permit(:name, :game_id, :type, :start_value, :min_value, :max_value)
      end
  end

end
