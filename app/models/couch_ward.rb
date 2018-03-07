class CouchWard < CouchRest::Model::Base
	use_database 'ward'

	property :name, String
end
