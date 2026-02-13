# frozen_string_literal: true

class CreateEquipmentProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :equipment_profiles, id: :string do |t|
      t.references :customer, null: false, foreign_key: true, type: :string, index: { unique: true }
      t.integer :height_cm
      t.decimal :weight_kg, precision: 5, scale: 1
      t.string :wetsuit_size
      t.integer :wetsuit_thickness_mm
      t.string :bcd_size
      t.string :boot_size
      t.string :fin_size
      t.string :glove_size
      t.boolean :owns_mask, default: false, null: false
      t.boolean :owns_computer, default: false, null: false
      t.boolean :owns_wetsuit, default: false, null: false
      t.boolean :owns_fins, default: false, null: false
      t.boolean :owns_bcd, default: false, null: false
      t.boolean :owns_regulator, default: false, null: false
      t.text :notes

      t.timestamps
    end
  end
end
