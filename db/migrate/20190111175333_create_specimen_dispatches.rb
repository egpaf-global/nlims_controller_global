class CreateSpecimenDispatches < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen_dispatches do |t|
         t.string :tracking_number
         t.string :dispatcher_name
         t.datetime :date_dispatched
	 t.timestamps
    end
  end
end
