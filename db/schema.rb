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

ActiveRecord::Schema.define(version: 20180306084726) do

  create_table "measure_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "measure_type_id"
    t.string "unit"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tracking_number"
    t.string "patient_id"
    t.string "sample_type_id"
    t.string "date_created"
    t.string "priority"
    t.string "specimen_status_id"
    t.string "sample_drawn_by_id"
    t.string "sample_drawn_by_name"
    t.string "sample_drawn_by_phone_number"
    t.string "target_lab"
    t.string "art_start_date"
    t.string "health_facility"
    t.string "ward_or_location_id"
    t.string "requested_by"
    t.string "date_sample_drawn"
    t.string "health_facility_district"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panel_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "patient_id"
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
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specimen_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "test_id"
    t.string "measure_id"
    t.string "result"
    t.string "doc_id"
    t.string "time_entered"
  end

  create_table "test_status_updates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "test_id"
    t.string "doc_id"
    t.string "time_updated"
    t.string "test_status_id"
    t.string "who_updated_id"
    t.string "who_updated_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "short_name"
    t.string "test_category_id"
    t.string "targetTAT"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "order_id"
    t.string "test_type_id"
    t.string "test_status_id"
    t.string "time_created"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "testtype_measures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "test_type_id"
    t.string "measure_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "app_name"
    t.string "partner"
    t.string "location"
    t.string "password"
    t.string "username"
    t.string "token"
    t.string "token_expiry_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "doc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
