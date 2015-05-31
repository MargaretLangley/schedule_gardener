# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20121114133600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "house_name"
    t.string   "street_number",    null: false
    t.string   "street_name",      null: false
    t.string   "address_line_2"
    t.string   "town",             null: false
    t.string   "post_code"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree

  create_table "appointment_slots", force: :cascade do |t|
    t.string   "time",          null: false
    t.string   "humanize_time", null: false
    t.integer  "value",         null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "person_id",    null: false
    t.integer  "appointee_id", null: false
    t.datetime "starts_at",    null: false
    t.datetime "ends_at",      null: false
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "appointments", ["appointee_id"], name: "index_appointments_on_appointee_id", using: :btree
  add_index "appointments", ["person_id"], name: "index_appointments_on_person_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "person_id",              null: false
    t.integer  "appointee_id",           null: false
    t.boolean  "by_phone"
    t.boolean  "by_visit"
    t.datetime "touch_from",             null: false
    t.boolean  "completed"
    t.text     "additional_information"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "contacts", ["appointee_id"], name: "index_contacts_on_appointee_id", using: :btree
  add_index "contacts", ["person_id"], name: "index_contacts_on_person_id", using: :btree

  create_table "gardens", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "gardens", ["person_id"], name: "index_gardens_on_person_id", using: :btree

  create_table "persons", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "first_name",             null: false
    t.string   "last_name",              null: false
    t.string   "email"
    t.string   "home_phone",             null: false
    t.string   "mobile"
    t.integer  "role",       default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "persons", ["user_id"], name: "index_persons_on_user_id", using: :btree

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "password_digest",                        null: false
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "email_verified",         default: false
    t.string   "verify_email_token"
    t.datetime "verify_email_sent_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
