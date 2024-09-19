class AddRoundToBeers < ActiveRecord::Migration[7.1]
  def change
    add_reference :beers, :round, null: true, foreign_key: true
  end
end
