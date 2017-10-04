class AddCheck < ActiveRecord::Migration[5.0]
  def change
    add_column :fuels, :checked, :boolean, null: false, default: false
  end
end
