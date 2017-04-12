class AddCarIdToBookings < ActiveRecord::Migration[5.0]
  def change
    add_reference :bookings, :car
  end
end
