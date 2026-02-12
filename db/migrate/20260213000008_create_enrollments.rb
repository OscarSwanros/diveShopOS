# frozen_string_literal: true

class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments, id: :string do |t|
      t.references :course_offering, null: false, foreign_key: true, type: :string
      t.references :customer, null: false, foreign_key: true, type: :string
      t.integer :status, default: 0, null: false
      t.datetime :enrolled_at
      t.datetime :completed_at
      t.references :certification, foreign_key: true, type: :string
      t.boolean :paid, default: false, null: false
      t.text :notes

      t.timestamps
    end

    add_index :enrollments, [ :course_offering_id, :customer_id ], unique: true
    add_index :enrollments, [ :course_offering_id, :status ]
  end
end
