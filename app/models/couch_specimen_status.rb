class CouchSpecimenStatus < CouchRest::Model::Base
	use_database 'specimen_statuses'

	property :name, String
end
