class CreateMeasureRanges < ActiveRecord::Migration[5.1]
  def change
    create_table :measure_ranges do |t|
    	t.references :measures
    	t.integer	:age_min
    	t.integer 	:age_max
    	t.integer 	:gender
    	t.decimal	:range_lower
    	t.decimal	:range_upper
    	t.string	:alphanumeric
    	t.string	:interpretation    	
     	t.timestamps
    end
  end
end
