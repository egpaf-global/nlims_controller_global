class CreateTestResults < ActiveRecord::Migration[5.1]
  def change
    create_table :test_results do |t|
    	t.references :test
    	t.references :measure

    	t.string :result
    	t.string :doc_id
    	t.datetime :time_entered
     	t.timestamps
    end
  end
end
