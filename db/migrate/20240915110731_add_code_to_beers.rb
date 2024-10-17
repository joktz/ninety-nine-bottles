class AddCodeToBeers < ActiveRecord::Migration[7.1]
  def change
    add_column :beers, :code, :integer
  end
end
