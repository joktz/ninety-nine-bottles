class CreatePlayerAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :player_answers do |t|
      t.references :player, null: false, foreign_key: true
      t.integer :answer
      t.references :round, null: false, foreign_key: true
      t.references :beer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
