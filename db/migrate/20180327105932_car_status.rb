class CarStatus < ActiveRecord::Migration[5.0]
  def change
    remove_column :cars, :available
    add_column :cars, :status, :integer, null: false, default: 0
  end
end
