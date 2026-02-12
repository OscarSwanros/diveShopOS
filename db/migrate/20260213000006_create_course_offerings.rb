# frozen_string_literal: true

class CreateCourseOfferings < ActiveRecord::Migration[8.1]
  def change
    create_table :course_offerings, id: :string do |t|
      t.references :course, null: false, foreign_key: true, type: :string
      t.references :organization, null: false, foreign_key: true, type: :string
      t.references :instructor, null: false, foreign_key: { to_table: :users }, type: :string
      t.date :start_date, null: false
      t.date :end_date
      t.integer :max_students, null: false
      t.integer :price_cents
      t.string :price_currency
      t.integer :status, default: 0, null: false
      t.text :notes

      t.timestamps
    end

    add_index :course_offerings, [ :organization_id, :start_date ]
    add_index :course_offerings, [ :organization_id, :status ]
    add_index :course_offerings, [ :instructor_id, :start_date ]
  end
end
