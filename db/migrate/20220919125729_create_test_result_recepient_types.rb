class CreateTestResultRecepientTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :test_result_recepient_types do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end

