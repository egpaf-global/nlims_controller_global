class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
    	t.string :app_name
    	t.string :partner
    	t.string :location
    	t.string :password
    	t.string :username
    	t.string :token
    	t.string :token_expiry_time
      	t.timestamps
    end
  end
end
