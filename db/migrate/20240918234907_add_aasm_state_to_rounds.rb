class AddAasmStateToRounds < ActiveRecord::Migration[7.1]
  def change
    add_column :rounds, :aasm_state, :string
  end
end
