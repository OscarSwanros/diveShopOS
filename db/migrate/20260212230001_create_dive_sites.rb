# frozen_string_literal: true

class CreateDiveSites < ActiveRecord::Migration[8.1]
  def change
    create_table :dive_sites, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :name, null: false
      t.text :description
      t.decimal :max_depth_meters, precision: 6, scale: 1
      t.integer :difficulty_level, default: 0, null: false
      t.decimal :latitude, precision: 10, scale: 7
      t.decimal :longitude, precision: 10, scale: 7
      t.string :location_description
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :dive_sites, [ :organization_id, :name ], unique: true
    add_index :dive_sites, [ :organization_id, :active ]
  end
end
