class CreateDrives < ActiveRecord::Migration[5.0]
  def change
    create_table :drives do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at, null: true
      t.integer :start_meter, null: false
      t.integer :end_meter, null: true

      t.timestamps
    end
  end
end
