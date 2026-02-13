# frozen_string_literal: true

class AddSlugsToAllModels < ActiveRecord::Migration[8.1]
  def change
    # Organization-scoped models
    %i[customers users courses dive_sites excursions equipment_items].each do |table|
      add_column table, :slug, :string, null: false, default: ""
      add_index table, [ :organization_id, :slug ], unique: true, name: "index_#{table}_on_org_and_slug"
    end

    # User-scoped
    add_column :instructor_ratings, :slug, :string, null: false, default: ""
    add_index :instructor_ratings, [ :user_id, :slug ], unique: true, name: "index_instructor_ratings_on_user_and_slug"

    # Customer-scoped
    %i[certifications medical_records customer_tanks].each do |table|
      add_column table, :slug, :string, null: false, default: ""
      add_index table, [ :customer_id, :slug ], unique: true, name: "index_#{table}_on_customer_and_slug"
    end

    # Course-scoped
    add_column :course_offerings, :slug, :string, null: false, default: ""
    add_index :course_offerings, [ :course_id, :slug ], unique: true, name: "index_course_offerings_on_course_and_slug"

    # CourseOffering-scoped
    %i[class_sessions enrollments].each do |table|
      add_column table, :slug, :string, null: false, default: ""
      add_index table, [ :course_offering_id, :slug ], unique: true, name: "index_#{table}_on_offering_and_slug"
    end

    # Excursion-scoped
    %i[trip_dives trip_participants].each do |table|
      add_column table, :slug, :string, null: false, default: ""
      add_index table, [ :excursion_id, :slug ], unique: true, name: "index_#{table}_on_excursion_and_slug"
    end

    # EquipmentItem-scoped
    add_column :service_records, :slug, :string, null: false, default: ""
    add_index :service_records, [ :equipment_item_id, :slug ], unique: true, name: "index_service_records_on_item_and_slug"
  end
end
