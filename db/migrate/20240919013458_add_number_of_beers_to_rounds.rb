class AddNumberOfBeersToRounds < ActiveRecord::Migration[7.1]
  def change
    add_column :rounds, :number_of_beers, :integer
  end
end
