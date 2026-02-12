# frozen_string_literal: true

class CreateMedicalRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_records, id: :string do |t|
      t.references :customer, null: false, foreign_key: true, type: :string
      t.integer :status, default: 0, null: false
      t.date :clearance_date
      t.date :expiration_date
      t.string :physician_name
      t.text :notes
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :medical_records, :discarded_at
    add_index :medical_records, [ :customer_id, :status ], name: "index_medical_records_on_customer_and_status"
  end
end
