# frozen_string_literal: true

class CreateCustomerTanks < ActiveRecord::Migration[8.1]
  def change
    create_table :customer_tanks, id: :string do |t|
      t.references :customer, null: false, foreign_key: true, type: :string
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :serial_number, null: false
      t.string :manufacturer
      t.string :material
      t.string :size
      t.date :last_vip_date
      t.date :vip_due_date
      t.date :last_hydro_date
      t.date :hydro_due_date
      t.text :notes

      t.timestamps
    end

    add_index :customer_tanks, [ :organization_id, :serial_number ], unique: true, name: "index_customer_tanks_on_org_serial_unique"
  end
end
