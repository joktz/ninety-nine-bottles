class AddRoundsToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :rounds, :integer
  end
end
