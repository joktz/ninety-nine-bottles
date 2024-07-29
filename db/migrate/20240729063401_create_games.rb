class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :title
      t.integer :rounds
      t.references :user, null: false, foreign_key: true
      t.integer :sessions
      t.string :round_mode
      t.string :inf_mode

      t.timestamps
    end
  end
end
