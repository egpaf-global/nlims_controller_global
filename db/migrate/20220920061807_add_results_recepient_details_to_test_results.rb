class AddResultsRecepientDetailsToTestResults < ActiveRecord::Migration[5.1]
  def change
    add_column :test_result_receipent_types, :, :string
    add_column :result_given, :boolean
  end
end
