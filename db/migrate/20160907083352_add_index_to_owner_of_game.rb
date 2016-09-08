class AddIndexToOwnerOfGame < ActiveRecord::Migration[5.0]
  def change
    add_index :gamfora_games, :owner_id
  end
end
