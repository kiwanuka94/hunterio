class CreateExportsCompaniesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :exports_companies, id: false do |t|
      t.integer :export_id
      t.integer :company_id
    end

    add_index :exports_companies, :export_id
    add_index :exports_companies, :company_id
  end
end
