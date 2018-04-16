class CreatePanels < ActiveRecord::Migration[5.1]
  def change
    create_table :panels do |t|
    	
    	t.references :panel_type
    	t.references :test_type
      	t.timestamps
    end
  end
end
