class CreateTesttypeMeasures < ActiveRecord::Migration[5.1]
  def change
    create_table :testtype_measures do |t|
    	t.references :test_type
    	t.references :measure
      	t.timestamps
    end
  end
end
