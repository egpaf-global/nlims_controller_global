require 'rest-client'
require 'couchrest'
require 'json'
require 'mysql2'

namespace :db do
	url1 = "http://gibo:amin9090!@localhost:5984/nlims_orders_repo26"

	desc "Task description"
	task ini_couch_db: :environment do
		db_name = "nlims_orders_repo51"
		url = "http://gibo:amin9090!@localhost:5984/#{db_name}"
		create_db = false
		
		begin
			res = JSON.parse(RestClient.get(url,:content_type =>'application/json'))
			
		rescue Exception => e
			res = JSON.parse(RestClient.put(url, :content_type => 'application/json'))	
			if (res['ok'])
				create_db = true
				puts "couch database: #{db_name} created successfuly"
			end	
		end

		if (create_db == true)
			file = JSON.parse(File.read("#{Rails.root}/db/seed_files/test_categories.json"))
		
				File.open("#{Rails.root}/db/seeder.sql", "a") do |txt|
						txt.puts "\r"  +  "INSERT INTO test_categories  VALUES"
				end
				count =  file.length
				counter = 1
				file.each do |file| 
								
					res  = JSON.parse(RestClient.post(url1,{'name': "#{file[1]}"}.to_json, :content_type => "application/json"))
					if (res['ok'] == true)
						_id = res['id'] 
						if (counter < count)
							File.open("#{Rails.root}/db/seeder.sql", "a") do |txt|
								txt.puts "\r"  +  "(" + "'" + "#{_id.to_s}" + "'" +  "," + "'" + file[1].to_s + "'" + ")" + ","
							end
						else
							File.open("#{Rails.root}/db/seeder.sql", "a") do |txt|
								txt.puts "\r"  +  "(" + "'" + "#{_id.to_s}" + "'" +  "," + "'" + file[1].to_s + "'" + ")" + ";"
							end
						end

					end
					counter = counter + 1				
				end		
			

		end


		db_name = "nlims_categories_repo"
		url = "http://gibo:amin9090!@localhost:5984/#{db_name}"
		create_db = false
		
		begin
			res = JSON.parse(RestClient.get(url,:content_type =>'application/json'))
			
		rescue Exception => e
			res = JSON.parse(RestClient.put(url, :content_type => 'application/json'))	
			if (res['ok'])
				create_db = true
				puts "couch database: #{db_name} created successfuly"
			end	
		end

		if (create_db == true)

		end

		db_name = "nlims_test_types_repo"
		url = "http://gibo:amin9090!@localhost:5984/#{db_name}"
		create_db = false
		
		begin
			res = JSON.parse(RestClient.get(url,:content_type =>'application/json'))
			
		rescue Exception => e
			res = JSON.parse(RestClient.put(url, :content_type => 'application/json'))	
			if (res['ok'])
				create_db = true
				puts "couch database: #{db_name} created successfuly"
			end	
		end

		if (create_db == true)

		end		

		

		
	end

	desc 'initialize mysql db'
	task ini_mysql_db: :environment do 
		res = CouchTestCategory.create(name: 'Microbiology', date_created: 'a')
		puts res._id
	end
end


