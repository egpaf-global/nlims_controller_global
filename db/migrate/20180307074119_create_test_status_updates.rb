class CreateTestStatusUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :test_status_updates do |t|
    	t.references :test
    	t.references :test_status

    	t.string :doc_id
    	t.string :time_updated
       	t.string :who_updated_id
    	t.string :who_updated_name
     	t.timestamps
    end
  end
end
