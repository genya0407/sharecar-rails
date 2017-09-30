class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
