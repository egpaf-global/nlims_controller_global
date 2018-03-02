class CouchTestType < CouchRest::Model::Base
	use_database 'test_types'
	
	property :_id, String
	property :name, String
	property :short_name, String
	property :test_category_id, String
	property :targetTAT, String

end
