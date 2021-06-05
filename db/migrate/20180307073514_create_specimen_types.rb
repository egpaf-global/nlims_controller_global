class CreateSpecimenTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :specimen_types do |t|
    	t.string :name, null: false
    	t.string :description
      t.timestamps
    end
  end
end
