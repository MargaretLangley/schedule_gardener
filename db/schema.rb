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

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "house_name"
    t.string   "street_number",    null: false
    t.string   "street_name",      null: false
    t.string   "address_line_2"
    t.string   "town",             null: false
    t.string   "post_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointment_slots", force: true do |t|
    t.string   "time",          null: false
    t.string   "humanize_time", null: false
    t.integer  "value",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", force: true do |t|
    t.integer  "contact_id"
    t.integer  "appointee_id"
    t.datetime "starts_at",    null: false
    t.datetime "ends_at",      null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["appointee_id"], name: "index_appointments_on_appointee_id", using: :btree
  add_index "appointments", ["contact_id"], name: "index_appointments_on_contact_id", using: :btree

  create_table "contacts", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "first_name", null: false
    t.string   "last_name"
    t.string   "email"
    t.string   "home_phone", null: false
    t.string   "mobile"
    t.string   "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "gardens", force: true do |t|
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "touches", force: true do |t|
    t.integer  "contact_id",             null: false
    t.boolean  "by_phone"
    t.boolean  "by_visit"
    t.datetime "touch_from",             null: false
    t.boolean  "completed"
    t.text     "additional_information"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "touches", ["contact_id"], name: "index_touches_on_contact_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "password_digest",                        null: false
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "email_verified",         default: false
    t.string   "verify_email_token"
    t.datetime "verify_email_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
