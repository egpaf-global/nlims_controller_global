class CouchOrder < CouchRest::Model::Base
	use_database 'orders'

	property :_id, String
	property :patient_id, String
	property :sample_type, String
	property :date_created, String
	property :priority, String
	property :sample_collector, {}
	property :specimen_status, String
	property :target_lab, String
	property :art_start_date, String
	property :health_facility, String
	property :ward_or_location, String
	property :requested_by, String
	property :date_sample_drawn, String
	property :health_facility_district, String

end
