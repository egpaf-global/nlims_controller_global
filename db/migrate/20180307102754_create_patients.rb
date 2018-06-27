class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
    	
    	t.string :patient_id
	    t.string :npid
	    t.string :first_name
      t.string :last_name
      t.string :middle_name
	    t.string :email
	    t.string :dob
	    t.string :phone_number
	    t.string :gender
      t.timestamps
     
    end
  end
end
