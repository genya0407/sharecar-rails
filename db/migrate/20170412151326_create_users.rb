class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.column :name, :text
      t.column :email, :text

      t.timestamps
    end
  end
end
