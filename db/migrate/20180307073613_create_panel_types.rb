class CreatePanelTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :panel_types do |t|
    	t.string :name, null: false
    	t.string :doc_id
     	t.timestamps
    end
  end
end
