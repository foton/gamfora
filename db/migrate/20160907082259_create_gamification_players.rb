class CreateGamificationPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :gamification_players do |t|
      t.references Gamification.player_class.to_s.downcase.to_sym, index: true  #t.references :game, foreign_key: true
      t.references :game, index: true
      t.timestamps
    end
  end
end
