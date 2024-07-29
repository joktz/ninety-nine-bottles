class AddGameToBeers < ActiveRecord::Migration[7.1]
  def change
    add_reference :beers, :game, null: false, foreign_key: true
  end
end
