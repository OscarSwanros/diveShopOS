# frozen_string_literal: true

class CreateTripDives < ActiveRecord::Migration[8.1]
  def change
    create_table :trip_dives, id: :string do |t|
      t.references :excursion, null: false, foreign_key: true, type: :string
      t.references :dive_site, null: false, foreign_key: true, type: :string
      t.integer :dive_number, null: false
      t.decimal :planned_max_depth_meters, precision: 6, scale: 1
      t.integer :planned_bottom_time_minutes
      t.text :notes

      t.timestamps
    end

    add_index :trip_dives, [ :excursion_id, :dive_number ], unique: true
  end
end
