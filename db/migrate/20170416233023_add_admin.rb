class AddAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :permission, :integer, null: false, default: 5 # default: member
  end
end
