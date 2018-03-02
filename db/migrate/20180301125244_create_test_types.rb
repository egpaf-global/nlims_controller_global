class CreateTestTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :test_types do |t|
    	t.string :name
    	t.string :short_name
    	t.string :test_category_id
    	t.string :targetTAT
    	t.string :doc_id
      	t.timestamps
    end
  end
end
