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

ActiveRecord::Schema.define(version: 20180614015933) do

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

  create_table "attached_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "filepath", null: false
    t.string "target_class"
    t.string "target_id"
    t.string "original"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorization_user_devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "device_id"
    t.bigint "authorization_id"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorization_id"], name: "index_authorization_user_devices_on_authorization_id"
    t.index ["device_id"], name: "index_authorization_user_devices_on_device_id"
    t.index ["user_id"], name: "index_authorization_user_devices_on_user_id"
  end

  create_table "authorizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.string "serial_number"
    t.string "key"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.integer "available_quantity"
    t.integer "amount"
    t.float "price", limit: 24
    t.string "contact_information"
    t.string "manufacturer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
  end

  create_table "authorizationservices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "servicename", null: false
    t.bigint "authorization_id"
    t.string "serviceprovider"
    t.float "price", limit: 24
    t.datetime "begin_date"
    t.integer "months"
    t.datetime "end_date"
    t.datetime "authorizationscraptime"
    t.string "describe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorization_id"], name: "index_authorizationservices_on_authorization_id"
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
    t.string "pgcode"
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "department_name", null: false
    t.string "manager_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id", default: 0
    t.string "pgcode"
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
    t.datetime "devicescraptime"
    t.index ["device_id"], name: "index_deviceservices_on_device_id"
  end

  create_table "employee_inductions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "employee_name"
    t.date "induction_date"
    t.bigint "department_id"
    t.integer "leader"
    t.text "fields_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_employee_inductions_on_department_id"
  end

  create_table "entry_processes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "process_name"
    t.integer "display_order"
    t.integer "responsible"
    t.integer "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "oslengthens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "otherservice_id"
    t.datetime "serviceenddate"
    t.datetime "bagindate"
    t.datetime "enddate"
    t.string "note"
    t.float "price", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["otherservice_id"], name: "index_oslengthens_on_otherservice_id"
  end

  create_table "otherservices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "servicename", null: false
    t.string "serviceprovider"
    t.float "price", limit: 24
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "describe"
    t.integer "closeremind", default: 0
    t.datetime "remindtime"
    t.integer "months"
  end

  create_table "partcategories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.string "partcategorycode"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pgcode"
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

  create_table "process_resources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "entry_process_id"
    t.string "resource_name"
    t.integer "default"
    t.integer "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_process_id"], name: "index_process_resources_on_entry_process_id"
  end

  create_table "rights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "right_name"
    t.string "right", comment: "权限码(控制器@动作)"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_rights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "role_id"
    t.bigint "right_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["right_id"], name: "index_role_rights_on_right_id"
    t.index ["role_id"], name: "index_role_rights_on_role_id"
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "role_name"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "siteinfos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "title"
    t.string "emailrecive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suppliers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "product_name"
    t.string "supplier_name"
    t.string "contact"
    t.string "contact_information"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_model_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "model"
    t.text "fields_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_model_configs_on_user_id"
  end

  create_table "user_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
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
    t.string "position"
    t.integer "is_quit", default: 0
    t.index ["department_id"], name: "index_users_on_department_id"
  end

  create_table "white_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "web_name"
    t.string "url"
    t.string "introduce"
    t.string "requester"
    t.integer "is_add", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "authorizationservices", "authorizations"
  add_foreign_key "consumablerecords", "consumables"
  add_foreign_key "consumablerecords", "users"
  add_foreign_key "devicerecords", "devices"
  add_foreign_key "devicerecords", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "deviceservices", "devices"
  add_foreign_key "partrecords", "devices"
  add_foreign_key "partrecords", "parts"
  add_foreign_key "parts", "devices"
  add_foreign_key "parts", "partcategories"
  add_foreign_key "users", "departments"
end
