class CreateSpecimen < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen do |t|
      t.references :specimen_type
    	t.references :specimen_status   
      t.string :tracking_number
      t.datetime :date_created
    	t.string :priority, null: false
    	t.string :drawn_by_id
    	t.string :drawn_by_name
    	t.string :drawn_by_phone_number
    	t.string :target_lab, null: false
    	t.datetime :art_start_date
    	t.string :sending_facility, null: false
    	t.string :requested_by, null: false
      t.string :district      
      t.timestamps
    end
  end
end

