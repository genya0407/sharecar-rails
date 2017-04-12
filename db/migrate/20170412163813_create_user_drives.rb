class CreateUserDrives < ActiveRecord::Migration[5.0]
  def change
    create_table :user_drives do |t|
      t.references :user
      t.references :drive

      t.timestamps
    end
  end
end
