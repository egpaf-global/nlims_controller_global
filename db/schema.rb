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

ActiveRecord::Schema.define(version: 20180311172951) do

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
    t.string "time_updated"
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
