class CreateOrganismDrugs < ActiveRecord::Migration[5.1]
  def change
    create_table :organism_drugs do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
