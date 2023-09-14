# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20230912082844) do

  create_table "data_anomalies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "data_type"
    t.string "data"
    t.string "site_name"
    t.string "tracking_number"
    t.string "couch_id"
    t.datetime "date_created"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_susceptibilities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "test_id"
    t.bigint "organisms_id"
    t.bigint "drug_id"
    t.string "zone"
    t.string "interpretation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "index_drug_susceptibilities_on_drug_id"
    t.index ["organisms_id"], name: "index_drug_susceptibilities_on_organisms_id"
    t.index ["test_id"], name: "index_drug_susceptibilities_on_test_id"
    t.index ["user_id"], name: "index_drug_susceptibilities_on_user_id"
  end

  create_table "drugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measure_ranges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "measures_id"
    t.integer "age_min"
    t.integer "age_max"
    t.integer "gender"
    t.decimal "range_lower", precision: 10
    t.decimal "range_upper", precision: 10
    t.string "alphanumeric"
    t.string "interpretation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measures_id"], name: "index_measure_ranges_on_measures_id"
  end

  create_table "measure_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "unit"
    t.bigint "measure_type_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_type_id"], name: "index_measures_on_measure_type_id"
  end

  create_table "organism_drugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panel_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "panel_type_id"
    t.bigint "test_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_type_id"], name: "index_panels_on_panel_type_id"
    t.index ["test_type_id"], name: "index_panels_on_test_type_id"
  end

  create_table "patients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "patient_number"
    t.string "name"
    t.string "email"
    t.date "dob"
    t.string "phone_number"
    t.string "gender"
    t.string "address"
    t.string "external_patient_number"
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referrals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "status"
    t.bigint "site_id"
    t.string "person"
    t.string "contacts"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_referrals_on_site_id"
    t.index ["user_id"], name: "index_referrals_on_user_id"
  end

  create_table "rejection_reasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results_acknwoledges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tracking_number"
    t.integer "test_id"
    t.datetime "result_date"
    t.string "acknwoledged_by"
    t.datetime "acknwoledged_at"
    t.boolean "acknwoledged_to_nlims"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "acknwoledment_level"
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "district"
    t.float "x", limit: 24
    t.float "y", limit: 24
    t.string "region"
    t.string "description"
    t.boolean "enabled"
    t.boolean "sync_status"
    t.string "site_code"
    t.string "application_port"
    t.string "host_address"
    t.string "couch_username"
    t.string "couch_password"
    t.integer "site_code_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "specimen_type_id"
    t.bigint "specimen_status_id"
    t.bigint "ward_id"
    t.string "tracking_number"
    t.string "couch_id"
    t.datetime "date_created"
    t.string "priority", null: false
    t.string "drawn_by_id"
    t.string "drawn_by_name"
    t.string "drawn_by_phone_number"
    t.string "target_lab", null: false
    t.datetime "art_start_date"
    t.string "sending_facility", null: false
    t.string "requested_by", null: false
    t.string "district"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "arv_number"
    t.string "art_regimen"
    t.index ["specimen_status_id"], name: "index_specimen_on_specimen_status_id"
    t.index ["specimen_type_id"], name: "index_specimen_on_specimen_type_id"
    t.index ["tracking_number"], name: "index_specimen_on_tracking_number"
    t.index ["ward_id"], name: "index_specimen_on_ward_id"
  end

  create_table "specimen_dispatch_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_dispatches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tracking_number"
    t.string "dispatcher"
    t.bigint "dispatcher_type_id"
    t.datetime "date_dispatched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "delivery_location"
    t.index ["dispatcher_type_id"], name: "index_specimen_dispatches_on_dispatcher_type_id"
  end

  create_table "specimen_status_trails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "specimen_id"
    t.bigint "specimen_status_id"
    t.datetime "time_updated"
    t.string "who_updated_id"
    t.string "who_updated_name"
    t.string "who_updated_phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specimen_id"], name: "index_specimen_status_trails_on_specimen_id"
    t.index ["specimen_status_id"], name: "index_specimen_status_trails_on_specimen_status_id"
  end

  create_table "specimen_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_organisms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_id"
    t.bigint "organism_id"
    t.bigint "result_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organism_id"], name: "index_test_organisms_on_organism_id"
    t.index ["result_id"], name: "index_test_organisms_on_result_id"
    t.index ["test_id"], name: "index_test_organisms_on_test_id"
  end

  create_table "test_panels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "panel_types_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["panel_types_id"], name: "index_test_panels_on_panel_types_id"
  end

  create_table "test_phases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_result_recepient_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_id"
    t.bigint "measure_id"
    t.string "result"
    t.datetime "time_entered"
    t.string "device_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_id"], name: "index_test_results_on_measure_id"
    t.index ["test_id"], name: "index_test_results_on_test_id"
  end

  create_table "test_status_trails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_id"
    t.bigint "test_status_id"
    t.datetime "time_updated"
    t.string "who_updated_id"
    t.string "who_updated_name"
    t.string "who_updated_phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "index_test_status_trails_on_test_id"
    t.index ["test_status_id"], name: "index_test_status_trails_on_test_status_id"
  end

  create_table "test_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.bigint "test_phase_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_phase_id"], name: "index_test_statuses_on_test_phase_id"
  end

  create_table "test_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_category_id"
    t.string "name", null: false
    t.string "short_name", limit: 200
    t.string "targetTAT"
    t.string "description"
    t.string "prevalence_threshold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_category_id"], name: "index_test_types_on_test_category_id"
  end

  create_table "tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "specimen_id"
    t.bigint "test_type_id"
    t.bigint "test_status_id"
    t.bigint "patient_id"
    t.string "created_by"
    t.bigint "panel_id"
    t.datetime "time_created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_result_receipent_types"
    t.boolean "result_given"
    t.date "date_result_given"
    t.index ["panel_id"], name: "index_tests_on_panel_id"
    t.index ["patient_id"], name: "index_tests_on_patient_id"
    t.index ["specimen_id"], name: "index_tests_on_specimen_id"
    t.index ["test_status_id"], name: "index_tests_on_test_status_id"
    t.index ["test_type_id"], name: "index_tests_on_test_type_id"
  end

  create_table "testtype_measures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_type_id"
    t.bigint "measure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_id"], name: "index_testtype_measures_on_measure_id"
    t.index ["test_type_id"], name: "index_testtype_measures_on_test_type_id"
  end

  create_table "testtype_organisms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_type_id"
    t.bigint "organism_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organism_id"], name: "index_testtype_organisms_on_organism_id"
    t.index ["test_type_id"], name: "index_testtype_organisms_on_test_type_id"
  end

  create_table "testtype_specimentypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_type_id"
    t.bigint "specimen_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specimen_type_id"], name: "index_testtype_specimentypes_on_specimen_type_id"
    t.index ["test_type_id"], name: "index_testtype_specimentypes_on_test_type_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "app_name", null: false
    t.string "partner", null: false
    t.string "location", null: false
    t.string "password", null: false
    t.string "username", null: false
    t.string "token", default: "xxxxxxx", null: false
    t.datetime "token_expiry_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visit_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "patient_id"
    t.bigint "visit_type_id"
    t.bigint "ward_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_visits_on_patient_id"
    t.index ["visit_type_id"], name: "index_visits_on_visit_type_id"
    t.index ["ward_id"], name: "index_visits_on_ward_id"
  end

  create_table "visittype_wards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "ward_id"
    t.bigint "visit_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visit_type_id"], name: "index_visittype_wards_on_visit_type_id"
    t.index ["ward_id"], name: "index_visittype_wards_on_ward_id"
  end

  create_table "wards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
