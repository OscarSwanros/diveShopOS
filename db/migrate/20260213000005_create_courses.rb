# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :name, null: false
      t.text :description
      t.string :agency, null: false
      t.string :level, null: false
      t.integer :course_type, default: 0, null: false
      t.integer :min_age
      t.integer :max_students, default: 8, null: false
      t.integer :duration_days
      t.integer :price_cents, default: 0, null: false
      t.string :price_currency, default: "USD", null: false
      t.text :prerequisites_description
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :courses, [ :organization_id, :name ], unique: true
    add_index :courses, [ :organization_id, :active ]
    add_index :courses, [ :organization_id, :agency ]
  end
end
