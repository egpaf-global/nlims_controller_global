class CouchTestStatus < CouchRest::Model::Base
	use_database 'test_statues'

	property :name, String
end
