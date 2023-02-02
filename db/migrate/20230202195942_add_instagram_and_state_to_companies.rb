class AddInstagramAndStateToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :instagram, :string
    add_column :companies, :state_code, :string
  end
end
