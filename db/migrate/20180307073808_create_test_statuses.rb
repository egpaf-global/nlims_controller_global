class CreateTestStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :test_statuses do |t|
        t.string :name, null: false
        t.references :test_phase
      	t.timestamps
    end
  end
end
