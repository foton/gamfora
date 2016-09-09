require 'test_helper'
module Gamfora
  class ActionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @game = gamfora_games(:got)
      ::ApplicationController.current_user=users(:game_owner)
      @action = gamfora_actions(:wedding_ruined)
    end

    test "should get index" do
      get game_actions_url(@game)
      assert_response :success
    end

    test "should get new" do
      get new_game_action_url(@game)
      assert_response :success
    end

    test "should create action" do
      user=users(:user2)
      assert_difference('Player.count') do
        post game_actions_url(@game), params: { action: { game_id: @game.id, key: "run_away", name: "Run, run, run away" } }
      end

      assert_redirected_to game_action_url(@game, Gamfora::Action.last)
    end

    test "should show action" do
      get game_action_url(@action.game, @action)
      assert_response :success
    end

    test "should get edit" do
      get edit_game_action_url(@game, @action)
      assert_response :success
    end

    test "should update action" do
      patch game_action_url(@action.game, @action), params: { action: { game_id: gamfora_games(:dn3d).id, user_id: @action.user_id } }
      assert_redirected_to game_action_url(gamfora_games(:dn3d), @action)
    end

    test "should destroy action" do
      assert_difference('Player.count', -1) do
        delete game_action_url(@game, @action)
      end

      assert_redirected_to game_actions_url(@game)
    end

  end
end
