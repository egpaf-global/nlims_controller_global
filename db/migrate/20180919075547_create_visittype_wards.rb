class CreateVisittypeWards < ActiveRecord::Migration[5.1]
  def change
    create_table :visittype_wards do |t|
      t.references :ward
      t.references :visit_type
      t.timestamps
    end
  end
end