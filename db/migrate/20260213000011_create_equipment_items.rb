# frozen_string_literal: true

class CreateEquipmentItems < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment_items, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.integer :category, null: false
      t.string :name, null: false
      t.string :serial_number
      t.string :size
      t.string :manufacturer
      t.string :model_name
      t.integer :status, default: 0, null: false
      t.boolean :life_support, default: false, null: false
      t.date :purchase_date
      t.date :last_service_date
      t.date :next_service_due
      t.text :notes

      t.timestamps
    end

    add_index :equipment_items, [ :organization_id, :category, :status ], name: "index_equipment_items_on_org_category_status"
    add_index :equipment_items, [ :organization_id, :category, :size, :status ], name: "index_equipment_items_on_org_category_size_status"
    add_index :equipment_items, [ :organization_id, :serial_number ], unique: true, where: "serial_number IS NOT NULL", name: "index_equipment_items_on_org_serial_unique"
    add_index :equipment_items, [ :organization_id, :life_support, :next_service_due ], name: "index_equipment_items_on_org_life_support_service"
  end
end
