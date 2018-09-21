class CouchPanelType < CouchRest::Model::Base

	use_database 'test_panels'

	property :name, String

end
