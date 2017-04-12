class DisableNullOfSomeColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :bookings, :car_id, :integer, null: false
    change_column :drives, :car_id, :integer, null: false
    change_column :users, :name, :string, null: false
  end
end
