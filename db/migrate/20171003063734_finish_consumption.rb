class FinishConsumption < ActiveRecord::Migration[5.0]
  def change
    add_column :consumptions, :finished, :boolean, null: false, default: false
  end
end
