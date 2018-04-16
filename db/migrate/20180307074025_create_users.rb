class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
    	t.string :app_name, null: false
    	t.string :partner, null: false
    	t.string :location, null: false
    	t.string :password, null: false
    	t.string :username, null: false
    	t.string :token, null: false, :default => 'xxxxxxx'
    	t.datetime :token_expiry_time
     	t.timestamps
    end
  end
end
