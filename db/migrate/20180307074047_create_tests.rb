class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
    		t.references :specimen
    		t.references :test_type
				t.references :test_status
				t.references :patient
				t.string 		 :created_by
				t.references :panel				
    	  t.datetime :time_created
      	t.timestamps
    end
  end
end
