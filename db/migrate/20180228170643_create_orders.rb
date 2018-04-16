class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
    	t.string :tracking_number
    	t.string :patient_id
    	t.string :sample_type_id
    	t.string :date_created
    	t.string :priority
    	t.string :specimen_status_id
    	t.string :sample_drawn_by_id
    	t.string :sample_drawn_by_name
    	t.string :sample_drawn_by_phone_number
    	t.string :target_lab
    	t.string :art_start_date
    	t.string :health_facility
    	t.string :ward_or_location_id
    	t.string :requested_by
        t.string :date_sample_drawn
        t.string :health_facility_district
    	t.string :doc_id
      	t.timestamps
    end
  end
end
