class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :gamfora_actions do |t|
      t.string :name
      t.string :key
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
