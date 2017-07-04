class AdmitNullForDriveStartAt < ActiveRecord::Migration[5.0]
  def change
    change_column :drives, :start_at, :datetime, null: true
  end
end
