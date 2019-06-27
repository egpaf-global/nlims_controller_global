class CreateMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :measures do |t|
    	t.string :name, null: false    
    	t.string :unit
      t.references :measure_type
      t.string  :description
      t.timestamps
    end
  end
end
