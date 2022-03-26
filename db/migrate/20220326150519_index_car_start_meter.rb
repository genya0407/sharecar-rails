class IndexCarStartMeter < ActiveRecord::Migration[7.0]
  def change
    add_index :drives, %i[car_id start_meter]
  end
end
