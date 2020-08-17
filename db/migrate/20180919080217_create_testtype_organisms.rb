class CreateTesttypeOrganisms < ActiveRecord::Migration[5.1]
  def change
    create_table :testtype_organisms do |t|

      t.references :test_type
      t.references :organism
      t.timestamps
    end
  end
end
