class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|

      t.references :patient
      t.references :visit_type
      t.references :ward
      t.timestamps
    end
  end
end
