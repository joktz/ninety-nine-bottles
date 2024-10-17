class RemoveRoundsFromGames < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :rounds, :integer
    remove_column :games, :sessions, :integer
    remove_column :games, :round_mode, :string
    remove_column :games, :inf_mode, :string
    add_column :games, :status, :integer, default: 0
  end
end
