class CreateFuels < ActiveRecord::Migration[5.0]
  def change
    create_table :fuels do |t|
      t.references :user
      t.references :car
      t.integer :amount, null: false
      t.date :refueled_date, null: false

      t.timestamps
    end
  end
end
