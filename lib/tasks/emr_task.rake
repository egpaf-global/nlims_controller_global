namespace :emr do
    desc "TODO"
    task create_user: :environment do
      
      
      config = YAML.load_file("#{Rails.root}/config/emr_connection.yml")
      username = config['username']
      password = config['password']
      protocol = config['protocol']
      port = config['port']


      url = "#{protocol}:#{port}/api/v1/lab/users"
	user = JSON.parse(RestClient.post(url,{'username': username,'password': password}.to_json, content_type: 'application/json')) 
  
    end
end

