class CreateBill < ActiveRecord::Migration[5.0]
  def change
    create_table :bills do |t|
      t.references :term, null: false
      t.references :user, null: false
      t.integer :amount, null: false
      t.datetime :paid_at

      t.timestamps
    end
  end
end
