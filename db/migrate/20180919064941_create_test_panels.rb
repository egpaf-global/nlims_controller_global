class CreateTestPanels < ActiveRecord::Migration[5.1]
  def change
    create_table :test_panels do |t|
      t.references :panel_types
      t.timestamps
    end
  end
end
