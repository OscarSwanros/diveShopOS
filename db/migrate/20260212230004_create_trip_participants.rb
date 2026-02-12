# frozen_string_literal: true

class CreateTripParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :trip_participants, id: :string do |t|
      t.references :excursion, null: false, foreign_key: true, type: :string
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.string :certification_level
      t.string :certification_agency
      t.integer :role, default: 0, null: false
      t.text :notes
      t.boolean :paid, default: false, null: false

      t.timestamps
    end

    add_index :trip_participants, [ :excursion_id, :email ]
  end
end
