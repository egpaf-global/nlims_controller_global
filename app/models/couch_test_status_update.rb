class CouchTestStatusUpdate < CouchRest::Model::Base
	use_database 'test_status_updates'

	property :test_id, String
	property :time_update, String
	property :test_status_id, String
	property :who_updated_id, String
	property :who_updated_name, String
<<<<<<< HEAD
	
=======
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
end
