class DeleteTermAndBill < ActiveRecord::Migration[5.0]
  def change
    drop_table :terms
    drop_table :bills
    remove_column :drives, :term_id
    remove_column :fuels, :term_id
  end
end
