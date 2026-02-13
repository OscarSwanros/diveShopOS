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

ActiveRecord::Schema[8.1].define(version: 2026_02_13_170315) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "api_tokens", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.datetime "last_used_at"
    t.string "name", null: false
    t.datetime "revoked_at"
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["token_digest"], name: "index_api_tokens_on_token_digest", unique: true
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

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
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "agency", "certification_level"], name: "index_certs_on_customer_agency_level"
    t.index ["customer_id", "slug"], name: "index_certifications_on_customer_and_slug", unique: true
    t.index ["customer_id"], name: "index_certifications_on_customer_id"
    t.index ["discarded_at"], name: "index_certifications_on_discarded_at"
    t.index ["issuing_organization_id"], name: "index_certifications_on_issuing_organization_id"
  end

  create_table "checklist_items", id: :string, force: :cascade do |t|
    t.string "auto_check_key"
    t.string "checklist_template_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", null: false
    t.boolean "required", default: true, null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_template_id", "position"], name: "index_checklist_items_on_checklist_template_id_and_position"
    t.index ["checklist_template_id", "slug"], name: "index_checklist_items_on_checklist_template_id_and_slug", unique: true
    t.index ["checklist_template_id"], name: "index_checklist_items_on_checklist_template_id"
  end

  create_table "checklist_responses", id: :string, force: :cascade do |t|
    t.boolean "auto_verified", default: false, null: false
    t.boolean "checked", default: false, null: false
    t.datetime "checked_at"
    t.string "checklist_item_id", null: false
    t.string "checklist_run_id", null: false
    t.string "completed_by_id"
    t.datetime "created_at", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["checklist_item_id"], name: "index_checklist_responses_on_checklist_item_id"
    t.index ["checklist_run_id", "checked"], name: "index_checklist_responses_on_checklist_run_id_and_checked"
    t.index ["checklist_run_id", "checklist_item_id"], name: "index_checklist_responses_on_run_and_item", unique: true
    t.index ["checklist_run_id"], name: "index_checklist_responses_on_checklist_run_id"
    t.index ["completed_by_id"], name: "index_checklist_responses_on_completed_by_id"
  end

  create_table "checklist_runs", id: :string, force: :cascade do |t|
    t.string "checkable_id"
    t.string "checkable_type"
    t.string "checklist_template_id", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "organization_id", null: false
    t.string "slug", null: false
    t.string "started_by_id", null: false
    t.integer "status", default: 0, null: false
    t.json "template_snapshot"
    t.datetime "updated_at", null: false
    t.index ["checkable_type", "checkable_id"], name: "index_checklist_runs_on_checkable_type_and_checkable_id"
    t.index ["checklist_template_id"], name: "index_checklist_runs_on_checklist_template_id"
    t.index ["organization_id", "checklist_template_id"], name: "index_checklist_runs_on_org_and_template"
    t.index ["organization_id", "slug"], name: "index_checklist_runs_on_organization_id_and_slug", unique: true
    t.index ["organization_id", "status"], name: "index_checklist_runs_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_checklist_runs_on_organization_id"
    t.index ["started_by_id"], name: "index_checklist_runs_on_started_by_id"
  end

  create_table "checklist_templates", id: :string, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "category", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "organization_id", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "active"], name: "index_checklist_templates_on_organization_id_and_active"
    t.index ["organization_id", "category"], name: "index_checklist_templates_on_organization_id_and_category"
    t.index ["organization_id", "slug"], name: "index_checklist_templates_on_organization_id_and_slug", unique: true
    t.index ["organization_id", "title"], name: "index_checklist_templates_on_organization_id_and_title", unique: true
    t.index ["organization_id"], name: "index_checklist_templates_on_organization_id"
  end

  create_table "class_sessions", id: :string, force: :cascade do |t|
    t.string "course_offering_id", null: false
    t.datetime "created_at", null: false
    t.string "dive_site_id"
    t.time "end_time"
    t.string "location_description"
    t.text "notes"
    t.date "scheduled_date", null: false
    t.integer "session_type", default: 0, null: false
    t.string "slug", default: "", null: false
    t.time "start_time", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["course_offering_id", "scheduled_date"], name: "index_class_sessions_on_offering_and_date"
    t.index ["course_offering_id", "slug"], name: "index_class_sessions_on_offering_and_slug", unique: true
    t.index ["course_offering_id"], name: "index_class_sessions_on_course_offering_id"
    t.index ["dive_site_id"], name: "index_class_sessions_on_dive_site_id"
  end

  create_table "course_offerings", id: :string, force: :cascade do |t|
    t.string "course_id", null: false
    t.datetime "created_at", null: false
    t.date "end_date"
    t.string "instructor_id", null: false
    t.integer "max_students", null: false
    t.text "notes"
    t.string "organization_id", null: false
    t.integer "price_cents"
    t.string "price_currency"
    t.string "slug", default: "", null: false
    t.date "start_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "slug"], name: "index_course_offerings_on_course_and_slug", unique: true
    t.index ["course_id"], name: "index_course_offerings_on_course_id"
    t.index ["instructor_id", "start_date"], name: "index_course_offerings_on_instructor_id_and_start_date"
    t.index ["instructor_id"], name: "index_course_offerings_on_instructor_id"
    t.index ["organization_id", "start_date"], name: "index_course_offerings_on_organization_id_and_start_date"
    t.index ["organization_id", "status"], name: "index_course_offerings_on_organization_id_and_status"
    t.index ["organization_id"], name: "index_course_offerings_on_organization_id"
  end

  create_table "courses", id: :string, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "agency", null: false
    t.integer "course_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_days"
    t.string "level", null: false
    t.integer "max_students", default: 8, null: false
    t.integer "min_age"
    t.string "name", null: false
    t.string "organization_id", null: false
    t.text "prerequisites_description"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "active"], name: "index_courses_on_organization_id_and_active"
    t.index ["organization_id", "agency"], name: "index_courses_on_organization_id_and_agency"
    t.index ["organization_id", "name"], name: "index_courses_on_organization_id_and_name", unique: true
    t.index ["organization_id", "slug"], name: "index_courses_on_org_and_slug", unique: true
    t.index ["organization_id"], name: "index_courses_on_organization_id"
  end

  create_table "customer_accounts", id: :string, force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.string "email", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "organization_id", null: false
    t.string "password_digest", null: false
    t.datetime "password_reset_sent_at"
    t.string "password_reset_token"
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_customer_accounts_on_confirmation_token", unique: true
    t.index ["customer_id"], name: "index_customer_accounts_on_customer_id", unique: true
    t.index ["organization_id", "email"], name: "index_customer_accounts_on_organization_id_and_email", unique: true
    t.index ["organization_id", "slug"], name: "index_customer_accounts_on_organization_id_and_slug", unique: true
    t.index ["organization_id"], name: "index_customer_accounts_on_organization_id"
    t.index ["password_reset_token"], name: "index_customer_accounts_on_password_reset_token", unique: true
  end

  create_table "customer_tanks", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.date "hydro_due_date"
    t.date "last_hydro_date"
    t.date "last_vip_date"
    t.string "manufacturer"
    t.string "material"
    t.text "notes"
    t.string "organization_id", null: false
    t.string "serial_number", null: false
    t.string "size"
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.date "vip_due_date"
    t.index ["customer_id", "slug"], name: "index_customer_tanks_on_customer_and_slug", unique: true
    t.index ["customer_id"], name: "index_customer_tanks_on_customer_id"
    t.index ["organization_id", "serial_number"], name: "index_customer_tanks_on_org_serial_unique", unique: true
    t.index ["organization_id"], name: "index_customer_tanks_on_organization_id"
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
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "active"], name: "index_customers_on_org_and_active"
    t.index ["organization_id", "email"], name: "index_customers_on_org_and_email", unique: true, where: "(email IS NOT NULL)"
    t.index ["organization_id", "last_name", "first_name"], name: "index_customers_on_org_and_name"
    t.index ["organization_id", "slug"], name: "index_customers_on_org_and_slug", unique: true
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
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "active"], name: "index_dive_sites_on_organization_id_and_active"
    t.index ["organization_id", "name"], name: "index_dive_sites_on_organization_id_and_name", unique: true
    t.index ["organization_id", "slug"], name: "index_dive_sites_on_org_and_slug", unique: true
    t.index ["organization_id"], name: "index_dive_sites_on_organization_id"
  end

  create_table "enrollments", id: :string, force: :cascade do |t|
    t.string "certification_id"
    t.datetime "completed_at"
    t.string "course_offering_id", null: false
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.datetime "declined_at"
    t.text "declined_reason"
    t.datetime "enrolled_at"
    t.text "notes"
    t.boolean "paid", default: false, null: false
    t.datetime "requested_at"
    t.text "safety_gate_results"
    t.string "slug", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["certification_id"], name: "index_enrollments_on_certification_id"
    t.index ["course_offering_id", "customer_id"], name: "index_enrollments_on_course_offering_id_and_customer_id", unique: true, where: "(status <> ALL (ARRAY[4, 5, 7]))"
    t.index ["course_offering_id", "slug"], name: "index_enrollments_on_offering_and_slug", unique: true
    t.index ["course_offering_id", "status"], name: "index_enrollments_on_course_offering_id_and_status"
    t.index ["course_offering_id"], name: "index_enrollments_on_course_offering_id"
    t.index ["customer_id"], name: "index_enrollments_on_customer_id"
  end

  create_table "equipment_items", id: :string, force: :cascade do |t|
    t.integer "category", null: false
    t.datetime "created_at", null: false
    t.date "last_service_date"
    t.boolean "life_support", default: false, null: false
    t.string "manufacturer"
    t.string "name", null: false
    t.date "next_service_due"
    t.text "notes"
    t.string "organization_id", null: false
    t.string "product_model"
    t.date "purchase_date"
    t.string "serial_number"
    t.string "size"
    t.string "slug", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "category", "size", "status"], name: "index_equipment_items_on_org_category_size_status"
    t.index ["organization_id", "category", "status"], name: "index_equipment_items_on_org_category_status"
    t.index ["organization_id", "life_support", "next_service_due"], name: "index_equipment_items_on_org_life_support_service"
    t.index ["organization_id", "serial_number"], name: "index_equipment_items_on_org_serial_unique", unique: true, where: "(serial_number IS NOT NULL)"
    t.index ["organization_id", "slug"], name: "index_equipment_items_on_org_and_slug", unique: true
    t.index ["organization_id"], name: "index_equipment_items_on_organization_id"
  end

  create_table "equipment_profiles", id: :string, force: :cascade do |t|
    t.string "bcd_size"
    t.string "boot_size"
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.string "fin_size"
    t.string "glove_size"
    t.integer "height_cm"
    t.text "notes"
    t.boolean "owns_bcd", default: false, null: false
    t.boolean "owns_computer", default: false, null: false
    t.boolean "owns_fins", default: false, null: false
    t.boolean "owns_mask", default: false, null: false
    t.boolean "owns_regulator", default: false, null: false
    t.boolean "owns_wetsuit", default: false, null: false
    t.datetime "updated_at", null: false
    t.decimal "weight_kg", precision: 5, scale: 1
    t.string "wetsuit_size"
    t.integer "wetsuit_thickness_mm"
    t.index ["customer_id"], name: "index_equipment_profiles_on_customer_id", unique: true
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
    t.string "slug", default: "", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "scheduled_date"], name: "index_excursions_on_organization_id_and_scheduled_date"
    t.index ["organization_id", "slug"], name: "index_excursions_on_org_and_slug", unique: true
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
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["user_id", "agency", "rating_level"], name: "index_instructor_ratings_on_user_agency_level", unique: true
    t.index ["user_id", "slug"], name: "index_instructor_ratings_on_user_and_slug", unique: true
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
    t.string "slug", default: "", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "slug"], name: "index_medical_records_on_customer_and_slug", unique: true
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

  create_table "service_records", id: :string, force: :cascade do |t|
    t.integer "cost_cents"
    t.string "cost_currency", default: "USD"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "equipment_item_id", null: false
    t.date "next_due_date"
    t.text "notes"
    t.string "performed_by", null: false
    t.date "service_date", null: false
    t.integer "service_type", null: false
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_item_id", "service_date"], name: "index_service_records_on_item_and_date"
    t.index ["equipment_item_id", "slug"], name: "index_service_records_on_item_and_slug", unique: true
    t.index ["equipment_item_id"], name: "index_service_records_on_equipment_item_id"
  end

  create_table "session_attendances", id: :string, force: :cascade do |t|
    t.boolean "attended", default: false, null: false
    t.string "class_session_id", null: false
    t.datetime "created_at", null: false
    t.string "enrollment_id", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["class_session_id", "enrollment_id"], name: "idx_on_class_session_id_enrollment_id_315dc234ff", unique: true
    t.index ["class_session_id"], name: "index_session_attendances_on_class_session_id"
    t.index ["enrollment_id"], name: "index_session_attendances_on_enrollment_id"
  end

  create_table "trip_dives", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dive_number", null: false
    t.string "dive_site_id", null: false
    t.string "excursion_id", null: false
    t.text "notes"
    t.integer "planned_bottom_time_minutes"
    t.decimal "planned_max_depth_meters", precision: 6, scale: 1
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["dive_site_id"], name: "index_trip_dives_on_dive_site_id"
    t.index ["excursion_id", "dive_number"], name: "index_trip_dives_on_excursion_id_and_dive_number", unique: true
    t.index ["excursion_id", "slug"], name: "index_trip_dives_on_excursion_and_slug", unique: true
    t.index ["excursion_id"], name: "index_trip_dives_on_excursion_id"
  end

  create_table "trip_participants", id: :string, force: :cascade do |t|
    t.string "certification_agency"
    t.string "certification_level"
    t.datetime "created_at", null: false
    t.string "customer_id"
    t.datetime "declined_at"
    t.text "declined_reason"
    t.string "email"
    t.string "excursion_id", null: false
    t.string "name", null: false
    t.text "notes"
    t.boolean "paid", default: false, null: false
    t.string "phone"
    t.datetime "requested_at"
    t.integer "role", default: 0, null: false
    t.text "safety_gate_results"
    t.string "slug", default: "", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_trip_participants_on_customer_id"
    t.index ["excursion_id", "customer_id"], name: "idx_trip_participants_excursion_customer_unique", unique: true, where: "((customer_id IS NOT NULL) AND (status <> 2))"
    t.index ["excursion_id", "email"], name: "index_trip_participants_on_excursion_id_and_email"
    t.index ["excursion_id", "slug"], name: "index_trip_participants_on_excursion_and_slug", unique: true
    t.index ["excursion_id"], name: "index_trip_participants_on_excursion_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "organization_id", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.string "slug", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "email_address"], name: "index_users_on_organization_id_and_email_address", unique: true
    t.index ["organization_id", "slug"], name: "index_users_on_org_and_slug", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  create_table "waitlist_entries", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_id", null: false
    t.datetime "expires_at"
    t.datetime "notified_at"
    t.string "organization_id", null: false
    t.integer "position", null: false
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "waitlistable_id", null: false
    t.string "waitlistable_type", null: false
    t.index ["customer_id"], name: "index_waitlist_entries_on_customer_id"
    t.index ["organization_id", "slug"], name: "index_waitlist_entries_on_organization_id_and_slug", unique: true
    t.index ["organization_id"], name: "index_waitlist_entries_on_organization_id"
    t.index ["waitlistable_type", "waitlistable_id", "customer_id"], name: "idx_waitlist_entries_on_waitlistable_and_customer", unique: true, where: "(status = 0)"
    t.index ["waitlistable_type", "waitlistable_id", "position"], name: "idx_waitlist_entries_on_waitlistable_and_position", unique: true
  end

  add_foreign_key "api_tokens", "users"
  add_foreign_key "certifications", "customers"
  add_foreign_key "certifications", "organizations", column: "issuing_organization_id"
  add_foreign_key "checklist_items", "checklist_templates"
  add_foreign_key "checklist_responses", "checklist_items"
  add_foreign_key "checklist_responses", "checklist_runs"
  add_foreign_key "checklist_responses", "users", column: "completed_by_id"
  add_foreign_key "checklist_runs", "checklist_templates"
  add_foreign_key "checklist_runs", "organizations"
  add_foreign_key "checklist_runs", "users", column: "started_by_id"
  add_foreign_key "checklist_templates", "organizations"
  add_foreign_key "class_sessions", "course_offerings"
  add_foreign_key "class_sessions", "dive_sites"
  add_foreign_key "course_offerings", "courses"
  add_foreign_key "course_offerings", "organizations"
  add_foreign_key "course_offerings", "users", column: "instructor_id"
  add_foreign_key "courses", "organizations"
  add_foreign_key "customer_accounts", "customers"
  add_foreign_key "customer_accounts", "organizations"
  add_foreign_key "customer_tanks", "customers"
  add_foreign_key "customer_tanks", "organizations"
  add_foreign_key "customers", "organizations"
  add_foreign_key "dive_sites", "organizations"
  add_foreign_key "enrollments", "certifications"
  add_foreign_key "enrollments", "course_offerings"
  add_foreign_key "enrollments", "customers"
  add_foreign_key "equipment_items", "organizations"
  add_foreign_key "equipment_profiles", "customers"
  add_foreign_key "excursions", "organizations"
  add_foreign_key "instructor_ratings", "users"
  add_foreign_key "medical_records", "customers"
  add_foreign_key "service_records", "equipment_items"
  add_foreign_key "session_attendances", "class_sessions"
  add_foreign_key "session_attendances", "enrollments"
  add_foreign_key "trip_dives", "dive_sites"
  add_foreign_key "trip_dives", "excursions"
  add_foreign_key "trip_participants", "customers"
  add_foreign_key "trip_participants", "excursions"
  add_foreign_key "users", "organizations"
  add_foreign_key "waitlist_entries", "customers"
  add_foreign_key "waitlist_entries", "organizations"
end
