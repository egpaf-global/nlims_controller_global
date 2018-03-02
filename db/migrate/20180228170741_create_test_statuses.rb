class CreateTestStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :test_statuses do |t|
    	t.string :name
    	t.string :doc_id
      	t.timestamps
    end
  end
end
