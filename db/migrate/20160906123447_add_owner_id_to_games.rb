class AddOwnerIdToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :gamfora_games, :owner_id, :integer
  end
end
