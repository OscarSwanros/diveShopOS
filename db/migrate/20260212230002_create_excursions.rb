# frozen_string_literal: true

class CreateExcursions < ActiveRecord::Migration[8.1]
  def change
    create_table :excursions, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :title, null: false
      t.text :description
      t.date :scheduled_date, null: false
      t.time :departure_time
      t.time :return_time
      t.integer :capacity, null: false
      t.integer :price_cents, default: 0, null: false
      t.string :price_currency, default: "USD", null: false
      t.integer :status, default: 0, null: false
      t.text :notes

      t.timestamps
    end

    add_index :excursions, [ :organization_id, :scheduled_date ]
    add_index :excursions, [ :organization_id, :status ]
  end
end
