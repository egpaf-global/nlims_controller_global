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

ActiveRecord::Schema.define(version: 20180803060256) do

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
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
    t.string "unit"
    t.bigint "measure_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_type_id"], name: "index_measures_on_measure_type_id"
  end

  create_table "orders", id: :string, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "specimen_type_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "specimen_status_id", null: false
    t.bigint "ward_id", null: false
    t.datetime "date_created"
    t.string "priority", null: false
    t.string "sample_drawn_by_id"
    t.string "sample_drawn_by_name"
    t.string "sample_drawn_by_phone_number"
    t.string "target_lab", null: false
    t.datetime "art_start_date"
    t.string "health_facility", null: false
    t.string "requested_by", null: false
    t.datetime "date_sample_drawn"
    t.string "health_facility_district"
    t.string "dispatcher_id"
    t.string "dispatcher_name"
    t.string "dispatcher_phone_number"
    t.datetime "date_dispatched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_orders_on_patient_id"
    t.index ["specimen_status_id"], name: "index_orders_on_specimen_status_id"
    t.index ["specimen_type_id"], name: "index_orders_on_specimen_type_id"
    t.index ["ward_id"], name: "index_orders_on_ward_id"
  end

  create_table "panel_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
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

  create_table "patients", id: :string, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "npid"
    t.string "name"
    t.string "email"
    t.string "dob"
    t.string "phone_number"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slave_orders", id: :string, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "sending_facility"
    t.string "sending_facility_resolved_to"
    t.string "receiving_facility"
    t.string "receiving_facility_resolved_to"
    t.string "sample_type"
    t.string "sample_type_resolved_to"
    t.string "who_order_first_name"
    t.string "who_order_last_name"
    t.string "who_order_id"
    t.string "who_order_phone"
    t.string "art_start_date"
    t.string "dispatched_date"
    t.string "date_drawn"
    t.string "date_received"
    t.string "date"
    t.string "district"
    t.string "order_location"
    t.string "order_location_resolved_to"
    t.string "priority"
    t.string "order_status"
    t.string "order_status_resolved_to"
  end

  create_table "slave_test_results", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "id"
    t.string "test_type"
    t.string "measure"
    t.string "measure_resolved_to"
    t.string "measure_value"
    t.string "resolving_status"
  end

  create_table "slave_tests", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "id"
    t.string "test_type"
    t.string "test_type_resolved_to"
    t.string "test_status"
    t.string "test_status_resolved_to"
    t.string "remarks"
    t.string "date_time_started"
    t.string "date_time_completed"
    t.string "resolving_status"
  end

  create_table "specimen_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_id"
    t.bigint "measure_id"
    t.string "result"
    t.string "doc_id"
    t.datetime "time_entered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measure_id"], name: "index_test_results_on_measure_id"
    t.index ["test_id"], name: "index_test_results_on_test_id"
  end

  create_table "test_status_updates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_id"
    t.bigint "test_status_id"
    t.string "doc_id"
    t.datetime "time_updated"
    t.string "who_updated_id"
    t.string "who_updated_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_id"], name: "index_test_status_updates_on_test_id"
    t.index ["test_status_id"], name: "index_test_status_updates_on_test_status_id"
  end

  create_table "test_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "test_category_id"
    t.string "name", null: false
    t.string "short_name", limit: 200
    t.string "targetTAT"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_category_id"], name: "index_test_types_on_test_category_id"
  end

  create_table "tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "order_id"
    t.bigint "test_type_id"
    t.bigint "test_status_id"
    t.datetime "time_created"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_tests_on_order_id"
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

  create_table "wards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
