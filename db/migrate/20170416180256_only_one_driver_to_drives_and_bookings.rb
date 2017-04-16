class OnlyOneDriverToDrivesAndBookings < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_drives
    drop_table :user_bookings
    add_reference :drives, :user
    add_reference :bookings, :user
  end
end
