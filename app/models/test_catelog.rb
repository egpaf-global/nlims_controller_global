class TestCatelog < CouchRest::Model::Base

    use_database 'test_catelog'

    property :_id, String
	property :specimen_type, {}
	property :test_type, {}
	property :measure_type, {}
	property :test_organism, {}
	property :test_panel, {}
	property :organism, {}
	property :ward, {}
	property :visit_type, {}
	property :rejection_reason, {}
	property :sites, {}
	property :specimen_status, {}
	property :test_status, {}
    property :testtype_measure, {}
    property :testtype_organism, {}
    property :test_phase, {}
    property :organism_drug, {}
    property :panel, {}
    property :test_category, {}


    

end
