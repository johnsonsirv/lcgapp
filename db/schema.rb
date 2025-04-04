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

ActiveRecord::Schema[8.0].define(version: 2025_04_02_144459) do
  create_table "events", id: :string, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "theme"
    t.integer "year"
    t.date "start_date"
    t.date "end_date"
    t.string "location"
    t.string "image_url"
    t.integer "status", default: 0
    t.string "short_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_date", "end_date"], name: "index_events_on_start_date_and_end_date"
    t.index ["status"], name: "index_events_on_status"
    t.index ["theme"], name: "index_events_on_theme", unique: true
    t.index ["year"], name: "index_events_on_year", unique: true
  end

  create_table "participants", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "phone_number", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "gender"
    t.date "ministry"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attended", default: false
    t.index ["email"], name: "index_participants_on_email"
    t.index ["event_id"], name: "index_participants_on_event_id"
    t.index ["first_name"], name: "index_participants_on_first_name"
    t.index ["last_name"], name: "index_participants_on_last_name"
    t.index ["phone_number"], name: "index_participants_on_phone_number", unique: true
  end

  add_foreign_key "participants", "events"
end
