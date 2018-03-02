class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
    	t.string :specimen_id
    	t.string :test_type_id
    	t.string :test_status_id
    	t.string :tested_by
    	t.string :verified_by
    	t.string :time_started
    	t.string :time_created
    	t.string :time_verified
    	t.string :time_completed
    	t.string :doc_id
     	t.timestamps
    end
  end
end
