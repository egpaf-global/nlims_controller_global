class CouchMeasureType < CouchRest::Model::Base
	use_database 'measure_types'

	property :name, String
		
end
