class UpdateFieldToResultAcknwoledgment < ActiveRecord::Migration[5.1]
  def change
    add_column :results_acknwoledges, :acknwoledment_level,  :int
  end
end


