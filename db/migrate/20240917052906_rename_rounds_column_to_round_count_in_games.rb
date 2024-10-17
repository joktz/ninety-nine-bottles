class RenameRoundsColumnToRoundCountInGames < ActiveRecord::Migration[7.1]
  def change
    rename_column :games, :rounds, :round_count
  end
end
