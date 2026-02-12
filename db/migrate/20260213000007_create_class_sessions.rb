# frozen_string_literal: true

class CreateClassSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :class_sessions, id: :string do |t|
      t.references :course_offering, null: false, foreign_key: true, type: :string
      t.integer :session_type, default: 0, null: false
      t.string :title
      t.date :scheduled_date, null: false
      t.time :start_time, null: false
      t.time :end_time
      t.string :location_description
      t.references :dive_site, foreign_key: true, type: :string
      t.text :notes

      t.timestamps
    end

    add_index :class_sessions, [ :course_offering_id, :scheduled_date ], name: "index_class_sessions_on_offering_and_date"
  end
end
