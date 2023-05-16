class AddSiteCodeNumberToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :site_code_number, :integer
  end
end
