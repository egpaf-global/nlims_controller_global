class CreateTestTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :test_types do |t|
    	t.references :test_category
    	t.string :name, null: false
    	t.string :short_name
    	t.string :targetTAT
    	t.string :doc_id
     	t.timestamps
    end
  end
end
