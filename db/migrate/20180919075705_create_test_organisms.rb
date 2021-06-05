class CreateTestOrganisms < ActiveRecord::Migration[5.1]
  def change
    create_table :test_organisms do |t|
      t.references :test
      t.references :organism
      t.references :result
      t.timestamps
    end
  end
end
