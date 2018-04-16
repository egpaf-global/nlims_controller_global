class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
    	t.string :order_id
    	t.string :test_type_id
    	t.string :test_status_id
    	t.string :time_created
       	t.string :doc_id
     	t.timestamps
    end
  end
end
