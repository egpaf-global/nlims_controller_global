class CouchSpecimenType < CouchRest::Model::Base
	use_database 'specimen_types'

	property :_id, String
	property :name, String

end
