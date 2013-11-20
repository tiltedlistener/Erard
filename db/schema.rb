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

ActiveRecord::Schema.define(version: 20131023043815) do

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.boolean  "billable"
  end

  add_index "contacts", ["student_id"], name: "index_contacts_on_student_id", using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "student_id"
    t.boolean  "paid",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "schedule"
    t.text     "log"
    t.boolean  "resolved"
  end

  add_index "lessons", ["student_id"], name: "index_lessons_on_student_id", using: :btree

  create_table "logs", force: true do |t|
    t.text     "body"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["student_id"], name: "index_logs_on_student_id", using: :btree

  create_table "newsletters", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.date     "delivery_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", force: true do |t|
    t.string   "title"
    t.float    "price"
    t.boolean  "purchased",  default: false
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "purchases", ["student_id"], name: "index_purchases_on_student_id", using: :btree

  create_table "roles", force: true do |t|
    t.integer  "rid"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "students", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "rate"
    t.integer  "invoice_period"
    t.date     "last_invoice"
  end

  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "time_intervals", force: true do |t|
    t.integer  "time_code"
    t.string   "time_label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timelength"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
    t.string   "role"
    t.integer  "timezone"
  end

end
