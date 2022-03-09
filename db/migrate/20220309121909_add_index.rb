class AddIndex < ActiveRecord::Migration[6.1]
  def change
    add_index(:drives, %i[user_id car_id])
    add_index(:fuels, %i[user_id car_id created_at])
    add_index(:payments, :created_at)
  end
end
