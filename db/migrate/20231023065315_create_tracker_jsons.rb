class CreateTrackerJsons < ActiveRecord::Migration[5.1]
  def change
    create_table :tracker_jsons do |t|
      t.json :tracker
      t.timestamps
    end
  end
end
