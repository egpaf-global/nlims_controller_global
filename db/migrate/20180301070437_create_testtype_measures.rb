class CreateTesttypeMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :testtype_measures do |t|
    	t.string :test_type_id
    	t.string :measure_type_id
      	t.timestamps
    end
  end
end
