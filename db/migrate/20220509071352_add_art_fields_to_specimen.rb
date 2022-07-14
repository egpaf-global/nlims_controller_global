class AddArtFieldsToSpecimen < ActiveRecord::Migration[5.1]
  def change
    add_column :specimen, :arv_number, :string
    add_column :specimen, :art_regimen, :string
  end
end
