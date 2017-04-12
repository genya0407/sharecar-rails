class CreateUserBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_bookings do |t|
      t.references :user
      t.references :booking

      t.timestamps
    end
  end
end
