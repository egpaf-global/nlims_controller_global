class CouchOrder < CouchRest::Model::Base
	use_database 'orders'

<<<<<<< HEAD

=======
	property :_id, String
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
	property :tracking_number, String
	property :patient_id, String
	property :sample_type, String
	property :date_created, String
	property :priority, String
<<<<<<< HEAD
	property :sample_collector, {}
=======
	property :sample_collector, String
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
	property :specimen_status, String
	property :target_lab, String
	property :art_start_date, String
	property :health_facility, String
	property :ward_or_location, String
	property :requested_by, String
	property :date_sample_drawn, String
	property :health_facility_district, String
<<<<<<< HEAD


=======
>>>>>>> 6dca82065ac6ac9c61e5b39195bbe0b4574ba920
end
