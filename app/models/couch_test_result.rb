class CouchTestResult < CouchRest::Model::Base
<<<<<<< HEAD

	use_database 'test_results'

	property :test_id, String
	property :measure, String
	property :result, String
	property :time_entered, String

end



=======
	use_database 'test_results'

	property :test_id, String
	property :measure_id, String
	property :result, String
	property :time_entered, String
end
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
