class CreateMeasureTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :measure_types do |t|
    	  t.string :name, null: false
      	t.timestamps
    end
  end
end