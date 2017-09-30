class CreateConsumptions < ActiveRecord::Migration[5.0]
  def change
    create_table :consumptions do |t|
      t.references :cars
      t.float :price
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
