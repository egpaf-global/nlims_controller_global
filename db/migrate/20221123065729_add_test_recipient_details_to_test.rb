class AddTestRecipientDetailsToTest < ActiveRecord::Migration[5.1]
  def change
    add_column :tests, :test_result_receipent_types,  :string
    add_column :tests, :result_given, :boolean
    add_column :tests, :date_result_given, :date
  end
end
