class CouchTestStatusUpdate < CouchRest::Model::Base
	use_database 'test_status_updates'

	property :test_id, String
	property :time_update, String
	property :test_status_id, String
	property :who_updated_id, String
	property :who_updated_name, String
	
end
