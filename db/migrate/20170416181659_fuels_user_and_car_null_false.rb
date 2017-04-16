class FuelsUserAndCarNullFalse < ActiveRecord::Migration[5.0]
  def change
    change_column :fuels, :user_id, :integer, null: false
    change_column :fuels, :car_id, :integer, null: false
  end
end
