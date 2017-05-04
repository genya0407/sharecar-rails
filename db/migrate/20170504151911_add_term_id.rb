class AddTermId < ActiveRecord::Migration[5.0]
  def change
    add_reference :drives, :term
    add_reference :fuels, :term
  end
end
