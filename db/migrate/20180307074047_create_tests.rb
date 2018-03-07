class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
    	t.references :order
    	t.references :test_type
    	t.references :test_status

    	t.string :time_created
       	t.string :doc_id
      	t.timestamps
    end
  end
end
