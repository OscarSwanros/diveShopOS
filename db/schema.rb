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

ActiveRecord::Schema[8.1].define(version: 2026_02_13_000004) do
  create_table "certifications", id: :string, force: :cascade do |t|
    t.string "agency", null: false
    t.string "certification_level", null: false
    t.string "certification_number"
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.datetime "discarded_at"
    t.date "expiration_date"
    t.date "issued_date"
    t.string "issuing_organization_id"
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["customer_id", "agency", "certification_level"], name: "index_certs_on_customer_agency_level"
    t.index ["customer_id"], name: "index_certifications_on_customer_id"
    t.index ["discarded_at"], name: "index_certifications_on_discarded_at"
    t.index ["issuing_organization_id"], name: "index_certifications_on_issuing_organization_id"
  end

  create_table "customers", id: :string, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.string "email"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "notes"
    t.string "organization_id", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["organization_id", "active"], name: "index_customers_on_org_and_active"
    t.index ["organization_id", "email"], name: "index_customers_on_org_and_email", unique: true, where: "email IS NOT NULL"
    t.index ["organization_id", "last_name", "first_name"], name: "index_customers_on_org_and_name"
    t.index ["organization_id"], name: "index_customers_on_organization_id"
  end

  create_table "dive_sites", id: :string, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "difficulty_level", default: 0, null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.string "location_description"
    t.decimal "longitude", precision: 10, scale: 7
    t.decimal "max_depth_meters", precision: 6, scale: 1
    t.string "name", null: false
    t.string "organization_id", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "active"], name: "index_dive_sites_on_organization_id_and_active"
    t.index ["organization_id", "name"], name: "index_dive_sites_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_dive_sites_on_organization_id"
  end

  create_table "excursions", id: :string, force: :cascade do |t|
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.time "departure_time"
    t.text "description"
    t.text "notes"
    t.string "organization_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.time "return_time"
    t.date "scheduled_date", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "scheduled_date"], name: "index_excursions_on_organization_id_and_scheduled_date"
    t.index ["organization_id", "status"], name: "index_excursions_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_excursions_on_organization_id"
  end

  create_table "instructor_ratings", id: :string, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "agency", null: false
    t.datetime "created_at", null: false
    t.date "expiration_date"
    t.string "rating_level", null: false
    t.string "rating_number"
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["user_id", "agency", "rating_level"], name: "index_instructor_ratings_on_user_agency_level", unique: true
    t.index ["user_id"], name: "index_instructor_ratings_on_user_id"
  end

  create_table "medical_records", id: :string, force: :cascade do |t|
    t.date "clearance_date"
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.datetime "discarded_at"
    t.date "expiration_date"
    t.text "notes"
    t.string "physician_name"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "status"], name: "index_medical_records_on_customer_and_status"
    t.index ["customer_id"], name: "index_medical_records_on_customer_id"
    t.index ["discarded_at"], name: "index_medical_records_on_discarded_at"
  end

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

  create_table "trip_dives", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dive_number", null: false
    t.string "dive_site_id", null: false
    t.string "excursion_id", null: false
    t.text "notes"
    t.integer "planned_bottom_time_minutes"
    t.decimal "planned_max_depth_meters", precision: 6, scale: 1
    t.datetime "updated_at", null: false
    t.index ["dive_site_id"], name: "index_trip_dives_on_dive_site_id"
    t.index ["excursion_id", "dive_number"], name: "index_trip_dives_on_excursion_id_and_dive_number", unique: true
    t.index ["excursion_id"], name: "index_trip_dives_on_excursion_id"
  end

  create_table "trip_participants", id: :string, force: :cascade do |t|
    t.string "certification_agency"
    t.string "certification_level"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "excursion_id", null: false
    t.string "name", null: false
    t.text "notes"
    t.boolean "paid", default: false, null: false
    t.string "phone"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["excursion_id", "email"], name: "index_trip_participants_on_excursion_id_and_email"
    t.index ["excursion_id"], name: "index_trip_participants_on_excursion_id"
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

  add_foreign_key "certifications", "customers"
  add_foreign_key "certifications", "organizations", column: "issuing_organization_id"
  add_foreign_key "customers", "organizations"
  add_foreign_key "dive_sites", "organizations"
  add_foreign_key "excursions", "organizations"
  add_foreign_key "instructor_ratings", "users"
  add_foreign_key "medical_records", "customers"
  add_foreign_key "trip_dives", "dive_sites"
  add_foreign_key "trip_dives", "excursions"
  add_foreign_key "trip_participants", "excursions"
  add_foreign_key "users", "organizations"
end
