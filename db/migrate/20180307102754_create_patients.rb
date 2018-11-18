class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      
	    t.string   :patient_number
	    t.string   :name
	    t.string   :email
	    t.date     :dob
	    t.string   :phone_number
	    t.string   :gender
      t.string   :address
      t.string   :external_patient_number
      t.integer  :created_by
      t.timestamps
     
    end
  end
end
