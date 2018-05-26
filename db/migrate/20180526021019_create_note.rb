class CreateNote < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :car
      t.string :body, null: false

      t.timestamps
    end
  end
end
