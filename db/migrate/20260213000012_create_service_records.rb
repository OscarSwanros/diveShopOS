# frozen_string_literal: true

class CreateServiceRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :service_records, id: :string do |t|
      t.references :equipment_item, null: false, foreign_key: true, type: :string
      t.integer :service_type, null: false
      t.date :service_date, null: false
      t.date :next_due_date
      t.string :performed_by, null: false
      t.integer :cost_cents
      t.string :cost_currency, default: "USD"
      t.text :description
      t.text :notes

      t.timestamps
    end

    add_index :service_records, [ :equipment_item_id, :service_date ], name: "index_service_records_on_item_and_date"
  end
end
