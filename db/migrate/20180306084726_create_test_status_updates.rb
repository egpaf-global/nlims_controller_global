class CreateTestStatusUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :test_status_updates do |t|
    	t.string :test_id
    	t.string :doc_id
    	t.string :time_updated
    	t.string :test_status_id
    	t.string :who_updated_id
    	t.string :who_updated_name
      	t.timestamps
    end
  end
end
