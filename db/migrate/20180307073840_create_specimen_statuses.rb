class CreateSpecimenStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen_statuses do |t|
    	t.string :name, null: false
     	t.timestamps
    end
  end
end
