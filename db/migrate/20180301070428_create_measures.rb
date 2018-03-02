class CreateMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :measures do |t|
    	t.string :name
    	t.string :measure_type_id
    	t.string :unit
    	t.string :doc_id
      	t.timestamps
    end
  end
end
