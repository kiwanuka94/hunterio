class CreateExports < ActiveRecord::Migration[7.0]
  def change
    create_table :exports do |t|
      t.integer :start_id
      t.integer :end_id

      t.timestamps
    end
  end
end
