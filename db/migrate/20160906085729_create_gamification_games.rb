class CreateGamificationGames < ActiveRecord::Migration[5.0]
  def change
    create_table :gamification_games do |t|
      t.string :name

      t.timestamps
    end
  end
end
