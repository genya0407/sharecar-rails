class AddCarNote < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :note, :string
  end
end
