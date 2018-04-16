class CouchTestResult < CouchRest::Model::Base

	use_database 'test_results'

	property :test_id, String
	property :measure, String
	property :result, String
	property :time_entered, String

end



