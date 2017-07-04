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

ActiveRecord::Schema.define(version: 20170704100002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.integer  "term_id",    null: false
    t.integer  "user_id",    null: false
    t.integer  "amount",     null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_bills_on_term_id", using: :btree
    t.index ["user_id"], name: "index_bills_on_user_id", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_at",   null: false
    t.datetime "end_at",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "car_id",     null: false
    t.integer  "user_id",    null: false
    t.index ["car_id"], name: "index_bookings_on_car_id", using: :btree
    t.index ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end

  create_table "cars", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drives", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "start_meter", null: false
    t.integer  "end_meter"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "car_id",      null: false
    t.integer  "user_id",     null: false
    t.integer  "term_id"
    t.index ["car_id"], name: "index_drives_on_car_id", using: :btree
    t.index ["term_id"], name: "index_drives_on_term_id", using: :btree
    t.index ["user_id"], name: "index_drives_on_user_id", using: :btree
  end

  create_table "fuels", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "car_id",     null: false
    t.integer  "amount",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "term_id"
    t.index ["car_id"], name: "index_fuels_on_car_id", using: :btree
    t.index ["term_id"], name: "index_fuels_on_term_id", using: :btree
    t.index ["user_id"], name: "index_fuels_on_user_id", using: :btree
  end

  create_table "terms", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                       null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer  "permission",                      default: 5, null: false
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "phone_number"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["activation_token"], name: "index_users_on_activation_token", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  end

end
