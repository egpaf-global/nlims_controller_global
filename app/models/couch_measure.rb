class CouchMeasure < CouchRest::Model::Base
	use_database 'measures'

	property :name, String
	property :unit, String
	property :measure_type, String
end
