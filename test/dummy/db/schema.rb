# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160916093248) do

  create_table "gamfora_actions", force: :cascade do |t|
    t.string   "name"
    t.string   "key"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_gamfora_actions_on_game_id"
  end

  create_table "gamfora_games", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "owner_id"
    t.index ["owner_id"], name: "index_gamfora_games_on_owner_id"
  end

  create_table "gamfora_metrics", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.string   "type"
    t.string   "values_json"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["game_id"], name: "index_gamfora_metrics_on_game_id"
  end

  create_table "gamfora_players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_gamfora_players_on_game_id"
    t.index ["user_id"], name: "index_gamfora_players_on_user_id"
  end

  create_table "gamfora_rewards", force: :cascade do |t|
    t.integer  "action_id"
    t.integer  "metric_id"
    t.integer  "count"
    t.string   "text_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_id"], name: "index_gamfora_rewards_on_action_id"
    t.index ["metric_id"], name: "index_gamfora_rewards_on_metric_id"
  end

  create_table "gamfora_scores", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "metric_id"
    t.integer  "count"
    t.string   "text_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_id"], name: "index_gamfora_scores_on_metric_id"
    t.index ["player_id"], name: "index_gamfora_scores_on_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
