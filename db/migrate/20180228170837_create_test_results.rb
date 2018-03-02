class CreateTestResults < ActiveRecord::Migration[5.1]
  def change
    create_table :test_results do |t|
    	t.string :test_id
    	t.string :measure_id
    	t.string :result
    	t.string :doc_id
	    t.timestamps
    end
  end
end
