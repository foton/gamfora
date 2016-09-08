class CreateGamforaGames < ActiveRecord::Migration[5.0]
  def change
    create_table :gamfora_games do |t|
      t.string :name

      t.timestamps
    end
  end
end
