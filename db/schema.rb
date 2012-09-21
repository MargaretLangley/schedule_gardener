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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120904095136) do

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "house_name"
    t.string   "street_number",    :null => false
    t.string   "street_name",      :null => false
    t.string   "address_line_2"
    t.string   "town",             :null => false
    t.string   "post_code"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "appointments", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "appointee_id"
    t.integer  "event_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "appointments", ["appointee_id"], :name => "index_appointments_on_appointee_id"
  add_index "appointments", ["contact_id"], :name => "index_appointments_on_contact_id"
  add_index "appointments", ["event_id"], :name => "index_appointments_on_event_id"

  create_table "contacts", :force => true do |t|
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.string   "first_name",       :null => false
    t.string   "last_name"
    t.string   "email"
    t.string   "home_phone",       :null => false
    t.string   "mobile"
    t.string   "role",             :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title",                          :null => false
    t.datetime "starts_at",                      :null => false
    t.datetime "ends_at"
    t.boolean  "all_day",     :default => false
    t.text     "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "gardens", :force => true do |t|
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "password_digest",                    :null => false
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
