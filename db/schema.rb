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

ActiveRecord::Schema[8.1].define(version: 2026_02_12_220355) do
  create_table "organizations", id: :string, force: :cascade do |t|
    t.string "brand_accent_color"
    t.string "brand_primary_color"
    t.datetime "created_at", null: false
    t.string "custom_domain"
    t.string "locale", default: "en", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "subdomain"
    t.string "tagline"
    t.string "time_zone", default: "UTC", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_domain"], name: "index_organizations_on_custom_domain", unique: true
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
    t.index ["subdomain"], name: "index_organizations_on_subdomain", unique: true
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "organization_id", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "email_address"], name: "index_users_on_organization_id_and_email_address", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "users", "organizations"
end
