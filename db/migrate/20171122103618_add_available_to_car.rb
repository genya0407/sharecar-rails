class AddAvailableToCar < ActiveRecord::Migration[5.0]
  def change
    add_column :cars, :available, :boolean, null: false, default: true
  end
end
