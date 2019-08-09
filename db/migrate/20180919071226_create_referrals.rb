class CreateReferrals < ActiveRecord::Migration[5.1]
  def change
    create_table :referrals do |t|
      t.integer :status
      t.references :site
      t.string :person
      t.string :contacts
      t.references :user
      t.timestamps
    end
  end
end

