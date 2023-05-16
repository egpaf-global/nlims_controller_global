class AddDeliveryLocationToSpecimenDispatches < ActiveRecord::Migration[5.1]
  def change
    add_column :specimen_dispatches, :delivery_location, :string
  end
end
