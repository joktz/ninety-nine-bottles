class AddAasmStateToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :aasm_state, :string
  end
end
