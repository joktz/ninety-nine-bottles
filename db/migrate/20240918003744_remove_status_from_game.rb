class RemoveStatusFromGame < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :status, :integer
  end
end
