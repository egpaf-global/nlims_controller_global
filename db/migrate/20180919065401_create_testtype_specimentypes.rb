class CreateTesttypeSpecimentypes < ActiveRecord::Migration[5.1]
  def change
    create_table :testtype_specimentypes do |t|
      t.references :test_type
      t.references :specimen_type
      t.timestamps
    end
  end
end