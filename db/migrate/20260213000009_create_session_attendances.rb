# frozen_string_literal: true

class CreateSessionAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :session_attendances, id: :string do |t|
      t.references :class_session, null: false, foreign_key: true, type: :string
      t.references :enrollment, null: false, foreign_key: true, type: :string
      t.boolean :attended, default: false, null: false
      t.text :notes

      t.timestamps
    end

    add_index :session_attendances, [ :class_session_id, :enrollment_id ], unique: true
  end
end
