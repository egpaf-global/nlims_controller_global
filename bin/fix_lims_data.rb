@fc_code = YAML.load_file("#{Rails.root}/config/application.yml")['facility_code']
@couchdb = YAML.load_file("#{Rails.root}/config/couchdb.yml")['development']

puts 'Please enter the path to BHT-EMR-API Format/Default: /var/www/BHT-EMR-API'

@bht_emr_path = gets.chomp

@art_db = unless @bht_emr_path
  YAML.load_file("#{@bht_emr_path}/config/database.yml")
else
  YAML.load_file("/var/www/BHT-EMR-API/config/database.yml")
end

def update_art(acc_num)
  updated_ac_num = 'X' + @fc_code + acc_num[4..(acc_num.length)]

  ActiveRecord::Base.connection.execute <<~SQL
  UPDATE #{@art_db['development']['database']}.orders
  SET accession_number = '#{updated_ac_num}'
  WHERE accession_number = '#{acc_num}'
SQL

end

def update_lims(acc_num)
  updated_ac_num = 'X' + @fc_code + acc_num[4..(acc_num.length)]
  url = @couchdb['protocol'] + '://' + @couchdb['host'] \
  		+ ':' + @couchdb['port'].to_s + '/' + @couchdb['prefix'] \
  		+ '_' + @couchdb['suffix']

  spec = Speciman.find_by(tracking_number: acc_num)

  if spec
	  spec.update(tracking_number: updated_ac_num)

	  couchdb_doc = `curl -XGET #{url}/#{spec.couch_id}`
	  couchdb_doc = JSON.parse(couchdb_doc)
	  couchdb_doc['tracking_number'] = updated_ac_num
	  
	  `curl -XPUT #{url}/#{spec.couch_id} -d #{couchdb_doc}` 
	  exit
  else
  	puts "Record not found"
  end
end

tracking_numbers = ActiveRecord::Base.connection.select_all <<~SQL
  SELECT accession_number 
  FROM #{@art_db['development']['database']}.orders 
  WHERE accession_number is not NULL;
SQL

tracking_numbers.each do |num|
  update_art(num['accession_number'])
  update_lims(num['accession_number'])
end

