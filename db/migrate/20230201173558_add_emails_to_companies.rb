class AddEmailsToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :email1, :string
    add_column :companies, :email2, :string
  end
end
