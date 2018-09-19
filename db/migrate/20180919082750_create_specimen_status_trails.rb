class CreateSpecimenStatusTrails < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen_status_trails do |t|

      t.timestamps
    end
  end
end
