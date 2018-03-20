class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients, {:id => false} do |t|
    	
    	t.string :id, primary_key: true
	    t.string :npid
	    t.string :name
	    t.string :email
	    t.string :dob
	    t.string :phone_number
	    t.string :gender
      t.timestamps
     
    end
  end
end
