class CreateGamforaMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :gamfora_metrics do |t|
      t.references :game, index: true
      t.string :name
      t.string :type
      t.string :values_json
      t.timestamps
    end
  end
end
