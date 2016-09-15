class CreeteScoresTable < ActiveRecord::Migration[5.0]
  def change
    create_table :gamfora_scores do |t|
      t.references :player, foreign_key: true
      t.references :metric, foreign_key: true
      t.integer    :count
      t.string     :text_value
      t.timestamps
    end
  end
end
