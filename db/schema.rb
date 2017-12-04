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

ActiveRecord::Schema.define(version: 20171204081104) do

  create_table "assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "asset_code", null: false
    t.string "asset_name", null: false
    t.string "service_sn"
    t.string "model"
    t.string "managed_by"
    t.string "asset_details"
    t.string "belong_to"
    t.integer "status"
    t.datetime "receive_date"
    t.datetime "first_date"
    t.datetime "scrap_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consumablerecords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "consumable_id"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumable_id"], name: "index_consumablerecords_on_consumable_id"
    t.index ["user_id"], name: "index_consumablerecords_on_user_id"
  end

  create_table "consumables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", null: false
    t.string "unit"
    t.integer "amount"
    t.integer "used_amount"
    t.integer "surplus_amount"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decategories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decategorycode"
    t.integer "parent_id"
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "department_name", null: false
    t.string "manager_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devicerecords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "device_id"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_devicerecords_on_device_id"
    t.index ["user_id"], name: "index_devicerecords_on_user_id"
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "asset_code"
    t.string "asset_name"
    t.string "service_sn"
    t.string "asset_details"
    t.integer "status", default: 1
    t.datetime "release_date"
    t.datetime "first_date"
    t.datetime "scrap_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "decategory_id"
    t.datetime "assign_time"
    t.integer "borrow_timeleft"
    t.integer "is_assign", default: 0
    t.string "location"
    t.integer "is_delete", default: 0
    t.integer "is_scrap", default: 0
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "deviceservices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "servicename", null: false
    t.bigint "device_id"
    t.string "serviceprovider"
    t.float "price", limit: 24
    t.datetime "begin_date"
    t.integer "months"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "describe"
    t.index ["device_id"], name: "index_deviceservices_on_device_id"
  end

  create_table "logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "ip", default: "0"
    t.string "controller"
    t.string "action"
    t.text "params"
    t.boolean "success", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oserviceimgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "imgurl", null: false
    t.bigint "otherservice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["otherservice_id"], name: "index_oserviceimgs_on_otherservice_id"
  end

  create_table "otherservices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "servicename", null: false
    t.string "serviceprovider"
    t.float "price", limit: 24
    t.datetime "begin_date"
    t.integer "months"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "describe"
  end

  create_table "partcategories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.string "partcategorycode"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partrecords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "part_id"
    t.bigint "device_id"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_partrecords_on_device_id"
    t.index ["part_id"], name: "index_partrecords_on_part_id"
  end

  create_table "parts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "part_code", null: false
    t.string "part_name", null: false
    t.string "part_details"
    t.integer "status"
    t.datetime "receive_date"
    t.datetime "assign_time"
    t.bigint "device_id"
    t.bigint "partcategory_id"
    t.integer "is_assign"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_parts_on_device_id"
    t.index ["partcategory_id"], name: "index_parts_on_partcategory_id"
  end

  create_table "serviceimgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "imgurl", null: false
    t.bigint "deviceservice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deviceservice_id"], name: "index_serviceimgs_on_deviceservice_id"
  end

  create_table "siteinfos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "title"
    t.string "emailrecive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "attendance"
    t.string "avatar"
    t.boolean "admin", default: false, null: false
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "department_id"
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  add_foreign_key "consumablerecords", "consumables"
  add_foreign_key "consumablerecords", "users"
  add_foreign_key "devicerecords", "devices"
  add_foreign_key "devicerecords", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "deviceservices", "devices"
  add_foreign_key "oserviceimgs", "otherservices"
  add_foreign_key "partrecords", "devices"
  add_foreign_key "partrecords", "parts"
  add_foreign_key "parts", "devices"
  add_foreign_key "parts", "partcategories"
  add_foreign_key "serviceimgs", "deviceservices"
  add_foreign_key "users", "departments"
end
