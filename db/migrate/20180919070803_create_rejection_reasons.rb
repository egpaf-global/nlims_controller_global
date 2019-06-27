class CreateRejectionReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :rejection_reasons do |t|
      t.string :reason
      t.timestamps
    end
  end
end