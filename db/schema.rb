# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[6.1].define(version: 2022_03_09_121909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", id: :serial, force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "car_id", null: false
    t.integer "user_id", null: false
    t.index ["car_id"], name: "index_bookings_on_car_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "cars", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.string "note"
  end

  create_table "consumptions", id: :serial, force: :cascade do |t|
    t.integer "car_id"
    t.float "price"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "finished", default: false, null: false
    t.index ["car_id"], name: "index_consumptions_on_car_id"
  end

  create_table "drives", id: :serial, force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "start_meter", null: false
    t.integer "end_meter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "car_id", null: false
    t.integer "user_id", null: false
    t.index ["car_id"], name: "index_drives_on_car_id"
    t.index ["user_id", "car_id"], name: "index_drives_on_user_id_and_car_id"
    t.index ["user_id"], name: "index_drives_on_user_id"
  end

  create_table "fuels", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "car_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "checked", default: false, null: false
    t.index ["car_id"], name: "index_fuels_on_car_id"
    t.index ["user_id", "car_id", "created_at"], name: "index_fuels_on_user_id_and_car_id_and_created_at"
    t.index ["user_id"], name: "index_fuels_on_user_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_payments_on_created_at"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "permission", default: 5, null: false
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at"
    t.string "phone_number"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

end
