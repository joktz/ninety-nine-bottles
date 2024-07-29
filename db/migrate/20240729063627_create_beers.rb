class CreateBeers < ActiveRecord::Migration[7.1]
  def change
    create_table :beers do |t|
      t.string :name
      t.string :style
      t.string :brewery
      t.string :origin
      t.integer :ibu
      t.float :alc_content
      t.float :latitude
      t.float :longitude
      t.string :photo

      t.timestamps
    end
  end
end
