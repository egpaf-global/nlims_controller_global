class CouchPatient < CouchRest::Model::Base

	use_database 'patient'

	property :name, String
	property :email, String
	property :gender, String
	property :patient_id, String
	property :phone_number, String
	property :dob,String

end
