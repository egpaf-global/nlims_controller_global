namespace :emr do
    desc "TODO"
    create_user: :environment do
      
      
      config = YAML.load_file("#{Rails.root}/config/emr_connection.yml")
      username = config['username']
      password = config['password']
      protocol = config['protocol']
      port = config['port']


      url = "#{protocol}:#{port}/api/v1/lab/users"
      user = JSON.parse(RestClient.post(url,{'username': username,'password': password,headers)) 
      if user['errors'][0] != "Username already exists" 
        puts "emr user created succussfuly"
      else
        puts  user['errors'][0]
      end
    end
end
