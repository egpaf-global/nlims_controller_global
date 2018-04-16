class CouchTestType < CouchRest::Model::Base
	use_database 'test_types'
	
	property :_id, String
	property :name, String
	property :short_name, String
	property :test_category_id, String
	property :targetTAT, String
<<<<<<< HEAD

=======
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
end
