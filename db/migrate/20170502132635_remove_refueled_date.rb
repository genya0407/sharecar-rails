class RemoveRefueledDate < ActiveRecord::Migration[5.0]
  def change
    remove_column :fuels, :refueled_date
  end
end
