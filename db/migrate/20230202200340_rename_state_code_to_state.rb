class RenameStateCodeToState < ActiveRecord::Migration[7.0]
  def change
    rename_column :companies, :state_code, :state
  end
end
