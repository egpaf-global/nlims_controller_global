namespace :emr do
    desc "TODO"
    create_user: :environment do
      
      

      config = YAML.load_file("#{Rails.root}/config/master_nlims.yml")
      username = config['username']
      password = config['password']
      protocol = config['protocol']
      port = config['port']
    end
end