class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, {:id => false}  do |t|
    	t.references :specimen_type, null: false
    	t.references :patient, null: false
    	t.references :specimen_status, null: false
    	t.references :ward, null: false

        t.string :id, primary_key: true
       	t.datetime :date_created
    	t.string :priority, null: false
    	t.string :sample_drawn_by_id
    	t.string :sample_drawn_by_name
    	t.string :sample_drawn_by_phone_number
    	t.string :target_lab, null: false
    	t.datetime :art_start_date
    	t.string :health_facility, null: false
    	t.string :requested_by, null: false
        t.datetime :date_sample_drawn
        t.string :health_facility_district
        t.string :dispatcher_id
        t.string :dispatcher_name
        t.string :dispatcher_phone_number
        t.datetime :date_dispatched
    	t.timestamps
    end
  end
end
