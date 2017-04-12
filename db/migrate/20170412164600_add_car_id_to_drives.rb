class AddCarIdToDrives < ActiveRecord::Migration[5.0]
  def change
    add_reference :drives, :car
  end
end
