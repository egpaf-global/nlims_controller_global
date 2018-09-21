class CouchTestCategory < CouchRest::Model::Base
	use_database 'test_category'

	property :_id, String
	property :name, String
	property :created_at, String
end
