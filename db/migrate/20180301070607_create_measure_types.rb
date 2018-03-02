class CreateMeasureTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :measure_types do |t|
    	t.string :name
    	t.string :doc_id
      	t.timestamps
    end
  end
end
