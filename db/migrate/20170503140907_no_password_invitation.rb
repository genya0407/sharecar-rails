class NoPasswordInvitation < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :name, :string, null: true
  end
end
