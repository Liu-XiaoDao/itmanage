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

ActiveRecord::Schema.define(version: 20171023004128) do

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

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
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
    t.bigint "user_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "nickname"
    t.string "avatar"
    t.boolean "admin", default: false, null: false
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "devices", "users"
end
