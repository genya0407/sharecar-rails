class NotNullToUserIdOfDrivesAndBookigs < ActiveRecord::Migration[5.0]
  def change
    change_column :drives, :user_id, :integer, null: false
    change_column :bookings, :user_id, :integer, null: false
  end
end
