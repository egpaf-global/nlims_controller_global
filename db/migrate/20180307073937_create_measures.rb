class CreateMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :measures do |t|
    	t.string :name, null: false
    	t.string :doc_id
    	t.string :unit
    	t.references :measure_type
      t.timestamps
    end
  end
end
